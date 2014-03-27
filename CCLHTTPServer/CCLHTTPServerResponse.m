#import "CCLHTTPServerResponse.h"

@implementation CCLHTTPServerResponse

+ (instancetype)responseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers body:(NSData *)body {
    return [[self alloc] initWithStatusCode:statusCode headers:headers body:body];
}

+ (instancetype)JSONResponseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers parameters:(id)parameters {
    NSError *error;
    NSData *body = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];

    if (headers == nil) {
        headers = @{
            @"Content-Type": @"application/json; charset=utf8",
        };
    } else if ([headers objectForKey:@"Content-Type"] == nil) {
        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
        mutableHeaders[@"Content-Type"] = @"application/json; charset=utf8";
        headers = mutableHeaders;
    }

    return [self responseWithStatusCode:statusCode headers:headers body:body];
}

+ (instancetype)propertyListResponseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers plist:(id)plist {
    NSString *error;
    NSData *body = [NSPropertyListSerialization dataFromPropertyList:plist format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];

    if (headers == nil) {
        headers = @{
            @"Content-Type": @"application/x-plist; charset=utf8",
        };
    } else if ([headers objectForKey:@"Content-Type"] == nil) {
        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
        mutableHeaders[@"Content-Type"] = @"application/x-plist; charset=utf8";
        headers = mutableHeaders;
    }


    return [self responseWithStatusCode:statusCode headers:headers body:body];
}

- (instancetype)initWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers body:(NSData *)body {
    if (self = [super init]) {
        _statusCode = statusCode;
        _headers = [headers copy];
        _body = [body copy];
    }

    return self;
}

@end