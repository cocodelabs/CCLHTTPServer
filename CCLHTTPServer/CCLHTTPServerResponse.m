#import "CCLHTTPServerResponse.h"

@implementation CCLHTTPServerResponse

+ (instancetype)responseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers body:(NSData *)body {
    return [[self alloc] initWithStatusCode:statusCode headers:headers body:body];
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