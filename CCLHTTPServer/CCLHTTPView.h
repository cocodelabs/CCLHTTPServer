#import <Foundation/Foundation.h>
#import "CCLHTTPServer.h"

@interface CCLHTTPView : NSObject

- (NSSet *)supportedMethods;

+ (id<CCLHTTPServerResponse>)handleRequest:(id<CCLHTTPServerRequest>)request;

@end