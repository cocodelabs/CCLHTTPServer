#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "CCLHTTPServer.h"

@interface CCLHTTPServerRequest : NSObject <CCLHTTPServerRequest>

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *HTTPVersion;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSData *body;

@end

@implementation CCLHTTPServerRequest

@end

@interface CCLHTTPServer () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) NSMutableSet *sockets;

@end

@implementation CCLHTTPServer

+ (NSString *)statusForCode:(NSUInteger)statusCode {
    NSDictionary *statusCodes = @{
        @200: @"OK",
        @201: @"CREATED",
        @202: @"ACCEPTED",
        @203: @"NON-AUTHORITATIVE INFORMATION",
        @204: @"NO CONTENT",
        @205: @"RESET CONTENT",
        @206: @"PARTIAL CONTENT",
        @400: @"BAD REQUEST",
        @401: @"UNAUTHORIZED",
        @402: @"PAYMENT REQUIRED",
        @403: @"FORBIDDEN",
        @404: @"NOT FOUND",
        @405: @"METHOD NOT ALLOWED",
        @406: @"NOT ACCEPTABLE",
        @407: @"PROXY AUTHENTICATION REQUIRED",
        @408: @"REQUEST TIMEOUT",
        @409: @"CONFLICT",
        @410: @"GONE",
        @411: @"LENGTH REQUIRED",
        @412: @"PRECONDITION FAILED",
        @413: @"REQUEST ENTITY TOO LARGE",
        @414: @"REQUEST-URI TOO LONG",
        @415: @"UNSUPPORTED MEDIA TYPE",
        @416: @"REQUESTED RANGE NOT SATISFIABLE",
        @417: @"EXPECTATION FAILED",
        @100: @"CONTINUE",
        @101: @"SWITCHING PROTOCOLS",
        @300: @"MULTIPLE CHOICES",
        @301: @"MOVED PERMANENTLY",
        @302: @"FOUND",
        @303: @"SEE OTHER",
        @304: @"NOT MODIFIED",
        @305: @"USE PROXY",
        @306: @"RESERVED",
        @307: @"TEMPORARY REDIRECT",
        @500: @"INTERNAL SERVER ERROR",
        @501: @"NOT IMPLEMENTED",
        @502: @"BAD GATEWAY",
        @503: @"SERVICE UNAVAILABLE",
        @504: @"GATEWAY TIMEOUT",
        @505: @"HTTP VERSION NOT SUPPORTED",
    };

    NSString *status = [statusCodes objectForKey:@(statusCode)];

    if (status == nil) {
        status = @"UNKNOWN";
    }

    return status;
}

- (instancetype)initWithInterface:(NSString *)interface port:(uint16_t)port {
    if (self = [super init]) {
        self.sockets = [NSMutableSet new];
        dispatch_queue_t delegateQueue = dispatch_queue_create("org.cocode.CCLHTTPServer", 0);
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:delegateQueue];

        NSError *error;
        if ([self.socket acceptOnInterface:interface port:port error:&error] == NO) {
            NSLog(@"%@: Error binding interface '%@' on port %ui %@", NSStringFromClass([self class]), interface, port, error);
            return nil;
        }
    }

    return self;
}

- (instancetype)initWithInterface:(NSString *)interface port:(uint16_t)port handler:(CCLHTTPRequestHandler)handler {
    if (self = [self initWithInterface:interface port:port]) {
        _handler = [handler copy];
    }

    return self;
}

- (void)stop {
    [self.socket disconnectAfterWriting];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    CCLHTTPServerRequest *request = [[CCLHTTPServerRequest alloc] init];
    newSocket.userData = request;

    [self.sockets addObject:newSocket];
    [newSocket readDataToData:[NSData dataWithBytes:"\r\n\r\n" length:4] withTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    [self.sockets removeObject:sock];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    CCLHTTPServerRequest *request = sock.userData;

    if (tag == 0) {
        NSString *payload = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSArray *lines = [payload componentsSeparatedByString:@"\r\n"];

        NSString *requestLine = [lines firstObject];
        lines = [lines subarrayWithRange:NSMakeRange(1, [lines count] - 3)];
        NSArray *requestWords = [requestLine componentsSeparatedByString:@" "];

        if ([requestWords count] == 3) {
            request.method = requestWords[0];
            request.path = requestWords[1];
            request.HTTPVersion = requestWords[2];

            if ([request.HTTPVersion hasPrefix:@"HTTP/1"] == NO) {
                NSString *body = [NSString stringWithFormat:@"Unsupported protocol (%@)", request.HTTPVersion];
                [self sendErrorStatusCode:400 body:body request:request socket:sock];
                return;
            }
        } else {
            NSString *body = [NSString stringWithFormat:@"Bad request syntax (%@)", requestLine];
            [self sendErrorStatusCode:400 body:body request:request socket:sock];
            return;
        }

        NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];

        for (NSString *line in lines) {
            NSRange seperatorRange = [line rangeOfString:@":"];

            if (seperatorRange.location != NSNotFound) {
                NSString *key = [line substringToIndex:seperatorRange.location];
                NSString *value = [line substringFromIndex:(seperatorRange.location + seperatorRange.length)];

                if ([value hasPrefix:@" "]) {
                    value = [value substringFromIndex:1];
                }

                headers[key] = value;
            } else {
                NSString *body = [NSString stringWithFormat:@"Bad header syntax (%@)", line];
                [self sendErrorStatusCode:400 body:body request:request socket:sock];
                return;
            }
        }

        request.headers = [headers copy];

        NSUInteger contentLength = [@([request.headers[@"Content-Length"] integerValue]) unsignedIntegerValue];
        if (contentLength) {
            [sock readDataToLength:contentLength withTimeout:-1 tag:1];
            return;
        }
    } else if (tag == 1) {
        request.body = data;
    }

    if (request) {
        id<CCLHTTPServerResponse> response = [self handleRequest:request];
        [self sendResponse:response request:request socket:sock];
    }
}

#pragma mark -

- (void)sendResponse:(id<CCLHTTPServerResponse>)response request:(id<CCLHTTPServerRequest>)request socket:(GCDAsyncSocket *)socket {
    if (request) {
        NSLog(@"[%@] \"%@ %@ %@\" %@ %@", [NSDate date], request.method, request.path, request.HTTPVersion, @(response.statusCode), @([response.body length]));
    }

    NSString *header = [NSString stringWithFormat:@"HTTP/1.1 %@ %@\r\n", @(response.statusCode), [CCLHTTPServer statusForCode:response.statusCode]];
    NSData *data = [header dataUsingEncoding:NSASCIIStringEncoding];
    [socket writeData:data withTimeout:-1 tag:1];

    NSMutableDictionary *headers = [response.headers mutableCopy];
    if (headers == nil) {
        headers = [[NSMutableDictionary alloc] init];
    }

    headers[@"Content-Length"] = @([response.body length]);
    headers[@"Connection"] = @"Close";

    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *header = [NSString stringWithFormat:@"%@: %@\r\n", key, obj];
        NSData *data = [header dataUsingEncoding:NSASCIIStringEncoding];
        [socket writeData:data withTimeout:-1 tag:1];
    }];

    [socket writeData:[NSData dataWithBytes:"\r\n" length:2] withTimeout:-1 tag:1];

    if ([response.body length]) {
        [socket writeData:response.body withTimeout:-1 tag:2];
    }

    if (request) {
        [socket disconnectAfterWriting];
    }
}

- (id<CCLHTTPServerResponse>)errorResponseWithStatus:(NSUInteger)status body:(NSString *)body {
    NSDictionary *headers = @{
        @"Content-type": @"text/plain; charset=utf-8",
    };

    return [[CCLHTTPServerResponse alloc] initWithStatusCode:status headers:headers body:[body dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)sendErrorStatusCode:(NSUInteger)statusCode body:(NSString *)body request:(id<CCLHTTPServerRequest>)request socket:(GCDAsyncSocket *)socket {
    id<CCLHTTPServerResponse> response = [self errorResponseWithStatus:statusCode body:body];
    [self sendResponse:response request:request socket:socket];
    [socket disconnectAfterWriting];
}

- (id<CCLHTTPServerResponse>)handleRequest:(id<CCLHTTPServerRequest>)request {
    id<CCLHTTPServerResponse> response = nil;

    if (self.handler) {
        response = self.handler(request);
    }

    if (response == nil) {
        response = [self errorResponseWithStatus:500 body:@"Internal Server Error"];
    }

    return response;
}

@end
