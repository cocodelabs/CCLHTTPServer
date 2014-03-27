#import "CCLHTTPServer.h"
#import "CCLHTTPView.h"

@implementation CCLHTTPView

+ (id<CCLHTTPServerResponse>)handleRequest:(id<CCLHTTPServerRequest>)request {
    CCLHTTPView *view = [[self alloc] init];
    return [view dispatchRequest:request];
}

- (NSSet *)supportedMethods {
    return [NSSet setWithObjects:@"GET", @"POST", @"PUT", @"PATCH", @"DELETE", @"HEAD", @"OPTIONS", @"TRACE", nil];
}

- (SEL)selectorForRequest:(id<CCLHTTPServerRequest>)request {
    SEL selector = @selector(httpMethodNotAllowed:);

    if ([[self supportedMethods] containsObject:[request method]]) {
        SEL methodSelector = NSSelectorFromString([[request method] stringByAppendingString:@":"]);

        if ([self respondsToSelector:methodSelector]) {
            selector = methodSelector;
        }
    }

    return selector;
}

- (id<CCLHTTPServerResponse>)dispatchRequest:(id<CCLHTTPServerRequest>)request {
    SEL selector = [self selectorForRequest:request];

    IMP implementation = [self methodForSelector:selector];
    id<CCLHTTPServerResponse> (*function)(id, SEL, id<CCLHTTPServerRequest>) = (void *)implementation;
    return function(self, selector, request);
}

- (id<CCLHTTPServerResponse>)httpMethodNotAllowed:(id<CCLHTTPServerRequest>)request {
    NSMutableArray *methods = [NSMutableArray array];

    for (NSString *method in [self supportedMethods]) {
        SEL methodSelector = NSSelectorFromString([method stringByAppendingString:@":"]);

        if ([self respondsToSelector:methodSelector]) {
            [methods addObject:method];
        }
    }

    NSDictionary *headers;
    if ([methods count]) {
        headers = @{ @"Allow": [methods componentsJoinedByString:@", "] };
    }

    return [CCLHTTPServerResponse responseWithStatusCode:405 headers:headers body:nil];
}

@end