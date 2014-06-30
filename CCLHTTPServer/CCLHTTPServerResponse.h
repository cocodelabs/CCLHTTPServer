#import <Foundation/Foundation.h>

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

/// A response conforming to the CCLHTTPServerResponse protcol
@interface CCLHTTPServerResponse : NSObject <CCLHTTPServerResponse>

@property (nonatomic, assign) NSUInteger statusCode;
@property (nonatomic, copy, readonly) NSDictionary *headers;
@property (nonatomic, copy, readonly) NSData *body;

/*** Initializes and returns a newly allocated response object with the
 * specified status code, headers and body.
 @param statusCode The status code for the response.
 @param headers The HTTP headers for the response.
 @param body The HTTP body for the response.
 @return The response.
*/
- (instancetype)initWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers body:(NSData *)body;

#pragma mark - Convinence responses

/*** A convinience method for generating a response with a status code, headers and a body.
 @param statusCode The status code for the response.
 @param headers The HTTP headers for the response.
 @param body The HTTP body for the response.
 @return The response.
*/
+ (instancetype)responseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers body:(NSData *)body;

/*** A convinience method for generating responses from a string.
 @param statusCode The status code for the response.
 @param headers The HTTP headers for the response.
 @param content The content to be unicode encoded.
 @param contentType The mime type for the content, for example plain/html.
 @return The  response.
 */
+ (instancetype)responseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers content:(NSString *)content contentType:(NSString *)contentType;

/*** A convinience method for generating a form URL encoded response.
 @param statusCode The status code for the response.
 @param headers The HTTP headers for the response.
 @param dictionary The dictionary to be form encoded.
 @return The form encoded response.
*/
+ (instancetype)formURLEncodedResponseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers dictionary:(NSDictionary *)dictionary;

/*** A convinience method for generating a JSON response.
 @param statusCode The status code for the response.
 @param headers The HTTP headers for the response.
 @param parameters The object to be JSON encoded.
 @return The JSON encoded response.
*/
+ (instancetype)JSONResponseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers parameters:(id)parameters;

/*** A convinience method for generating a property list response.
 @param statusCode The status code for the response.
 @param headers The HTTP headers for the response.
 @param plist The object to be property list encoded.
 @return The property list encoded response.
*/
+ (instancetype)propertyListResponseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers plist:(id)plist;

@end

