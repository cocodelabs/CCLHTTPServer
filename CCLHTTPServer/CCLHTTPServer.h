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

/*** Create a HTTP server and bind to the interface and port.
 @param interface The interface may be specified by name (e.g. "en1" or "lo0") or by IP address (e.g. "192.168.4.34"). You may also use the special strings "localhost" or "loopback" to specify that the socket only accept connections from the local machine. To accept connections on any interface pass nil.
 @param port The port to listen for connections on.
 */
- (instancetype)initWithInterface:(NSString *)interface port:(uint16_t)port;

/*** Create a HTTP server and bind to the interface and port providing a callback block for each request.
 @param interface The interface may be specified by name (e.g. "en1" or "lo0") or by IP address (e.g. "192.168.4.34"). You may also use the special strings "localhost" or "loopback" to specify that the socket only accept connections from the local machine. To accept connections on any interface pass nil.
 @param port The port to listen for connections on.
 @param handler The block to handle each HTTP request, this block should return a response.
 */
- (instancetype)initWithInterface:(NSString *)interface port:(uint16_t)port handler:(CCLHTTPRequestHandler)handler;

/// Stop listening for connections.
- (void)stop;

@end
