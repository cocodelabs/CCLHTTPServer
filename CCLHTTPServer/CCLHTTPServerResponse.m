#import "CCLHTTPServerResponse.h"

@implementation CCLHTTPServerResponse

- (instancetype)initWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers body:(NSData *)body {
    if (self = [super init]) {
        _statusCode = statusCode;
        _headers = [headers copy];
        _body = [body copy];
    }

    return self;
}

@end