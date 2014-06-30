#import <Foundation/Foundation.h>
#import "CCLHTTPServer.h"

/** A view is a way to create an object for dealing with HTTP requests. The
 view class allows you to organise your code related to specific HTTP methods
 (GET, POST, etc), which can be addressed by separate methods in the view
 subclass instead of conditional branching.
*/
@interface CCLHTTPView : NSObject

/*** All the supported HTTP methods for the view.
 @return Returns all the supported HTTP methods for the view as a set.
*/
- (NSSet *)supportedMethods;

/*** A method to handle the HTTP request and return a response for the request.
 @param request The HTTP request to handle.
 @return Returns a response for the request.
 */
+ (id<CCLHTTPServerResponse>)handleRequest:(id<CCLHTTPServerRequest>)request;

@end
