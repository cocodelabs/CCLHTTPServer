#import <Foundation/Foundation.h>
#import "CCLHTTPServerResponse.h"

/// A protocol for a HTTP request object
@protocol CCLHTTPServerRequest <NSObject>

/*** A string representing the HTTP method used in the request.
 @return The HTTP Method. Example `GET`
*/
- (NSString *)method;

/*** A string representing the full path to the requested page, not including the domain.
 @return A request path. Example `/users/kyle/`
*/
- (NSString *)path;

/*** A string representing the HTTP version which was used to make the request.
 @return The HTTP Version, for example `1.1`.
*/
- (NSString *)HTTPVersion;

/*** A dictionary containing all the HTTP headers for the request.
 @return A dictionary containing all the HTTP headers for the request.
*/
- (NSDictionary *)headers;

/*** The raw HTTP request body as NSData.
 @return The HTTP body as NSData.
*/
- (NSData *)body;

@end

typedef id<CCLHTTPServerResponse> (^CCLHTTPRequestHandler)(id<CCLHTTPServerRequest> request);

/** A HTTP Server using the CCLHTTPServerRequest protocol to handle requests. */

@interface CCLHTTPServer : NSObject

/*** The handler for each request. */
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

