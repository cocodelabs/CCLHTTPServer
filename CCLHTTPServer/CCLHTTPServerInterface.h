#import <Foundation/Foundation.h>

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

/// A protocol for a HTTP response object
@protocol CCLHTTPServerResponse <NSObject>

/*** The HTTP status code for the response.
 @return The HTTP status code for the response, as an unsigned integer.
 */
- (NSUInteger)statusCode;

/***
 @return All the HTTP headers for the response as a dictionary.
 */
- (NSDictionary *)headers;

/*** The HTTP body for the response, as NSData.
 @return The HTTP body for the response as data.
 */
- (NSData *)body;

@end

/// The webserver interface handler
typedef id<CCLHTTPServerResponse> (^CCLHTTPRequestHandler)(id<CCLHTTPServerRequest> request);
