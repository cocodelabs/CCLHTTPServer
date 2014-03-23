#import <Foundation/Foundation.h>
#import "CCLHTTPServerResponse.h"

@protocol CCLHTTPServerRequest <NSObject>

- (NSString *)method;
- (NSString *)path;
- (NSString *)HTTPVersion;
- (NSDictionary *)headers;
- (NSData *)body;

@end

typedef id<CCLHTTPServerResponse> (^CCLHTTPRequestHandler)(id<CCLHTTPServerRequest> request);

@interface CCLHTTPServer : NSObject

@property (nonatomic, copy, readonly) CCLHTTPRequestHandler handler;

- (instancetype)initWithInterface:(NSString *)interface port:(uint16_t)port;
- (instancetype)initWithInterface:(NSString *)interface port:(uint16_t)port handler:(CCLHTTPRequestHandler)handler;

@end
