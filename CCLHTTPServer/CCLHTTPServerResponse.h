#import <Foundation/Foundation.h>

@protocol CCLHTTPServerResponse <NSObject>

- (NSUInteger)statusCode;
- (NSDictionary *)headers;
- (NSData *)body;

@end

@interface CCLHTTPServerResponse : NSObject <CCLHTTPServerResponse>

@property (nonatomic, assign) NSUInteger statusCode;
@property (nonatomic, copy, readonly) NSDictionary *headers;
@property (nonatomic, copy, readonly) NSData *body;

- (instancetype)initWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers body:(NSData *)body;

#pragma mark - Convinence responses

+ (instancetype)responseWithStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers body:(NSData *)body;

@end