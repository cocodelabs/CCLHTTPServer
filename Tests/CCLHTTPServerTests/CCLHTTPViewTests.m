//
//  CCLHTTPViewTests.m
//  CCLHTTPServer
//
//  Created by Kyle Fuller on 27/03/2014.
//  Copyright (c) 2014 Cocode. All rights reserved.
//

#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import <CCLHTTPServer/CCLHTTPView.h>

@interface CCLHTTPTestRequest : NSObject <CCLHTTPServerRequest>

@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *HTTPVersion;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSData *body;

@end

@implementation CCLHTTPTestRequest

@end

@interface CCLHTTPViewTestExample : CCLHTTPView

@end

@implementation CCLHTTPViewTestExample

- (id <CCLHTTPServerResponse>)GET:(id <CCLHTTPServerRequest>)request {
    return [CCLHTTPServerResponse responseWithStatusCode:201 headers:nil body:nil];
}

- (id <CCLHTTPServerResponse>)PATCH:(id <CCLHTTPServerRequest>)request {
    return [CCLHTTPServerResponse responseWithStatusCode:201 headers:nil body:nil];
}

@end

@interface CCLHTTPViewTests : XCTestCase

@property (nonatomic, strong) CCLHTTPTestRequest *request;

@end

@implementation CCLHTTPViewTests

- (void)setUp {
    self.request = [[CCLHTTPTestRequest alloc] init];
    self.request.method = @"GET";
}

- (void)testDefaultViewReturns405 {
    id <CCLHTTPServerResponse> response = [CCLHTTPView handleRequest:self.request];

    expect([response statusCode]).to.equal(405);
}

- (void)testImplementingMethodUsesMethod {
    id <CCLHTTPServerResponse> response = [CCLHTTPViewTestExample handleRequest:self.request];

    expect([response statusCode]).to.equal(201);
}

- (void)testReturns405WithAllowedMethods {
    self.request.method = @"POST";
    id <CCLHTTPServerResponse> response = [CCLHTTPViewTestExample handleRequest:self.request];

    expect([response statusCode]).to.equal(405);
    expect([[response headers] objectForKey:@"Allow"]).to.equal(@"GET, PATCH");
}

@end
