//
//  CCLHTTPServerTests.m
//  CCLHTTPServerTests
//
//  Created by Kyle Fuller on 23/03/2014.
//  Copyright (c) 2014 Cocode. All rights reserved.
//

#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import <CCLHTTPServer/CCLHTTPServer.h>


@interface CCLHTTPServerResponseTests : XCTestCase

@end

@implementation CCLHTTPServerResponseTests

- (void)testConformsToHTTPServerResponseProtocol {
    CCLHTTPServerResponse *response = [[CCLHTTPServerResponse alloc] init];
    expect(response).to.conformTo(@protocol(CCLHTTPServerResponse));
}

- (void)testHasStatusCode {
    CCLHTTPServerResponse *response = [[CCLHTTPServerResponse alloc] initWithStatusCode:201 headers:nil body:nil];
    expect(response.statusCode).to.equal(201);
}

- (void)testEncodesJSONResponse {
    CCLHTTPServerResponse *response = [CCLHTTPServerResponse JSONResponseWithStatusCode:200 headers:nil parameters:@{@"key": @"value"}];

    NSData *body = [response body];
    NSString *decodedBody = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];

    expect([response statusCode]).to.equal(200);
    expect([response headers]).notTo.beNil();
    expect([[response headers] objectForKey:@"Content-Type"]).to.equal(@"application/json; charset=utf8");
    expect(body).notTo.beNil();
    expect(decodedBody).to.equal(@"{\"key\":\"value\"}");
}

- (void)testEncodesJSONResponseDoesntOverideHeaders {
    CCLHTTPServerResponse *response = [CCLHTTPServerResponse JSONResponseWithStatusCode:200 headers:@{@"Test": @"Value"} parameters:@{@"key": @"value"}];

    NSData *body = [response body];
    NSString *decodedBody = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];

    expect([response statusCode]).to.equal(200);
    expect([response headers]).notTo.beNil();
    expect([[response headers] objectForKey:@"Content-Type"]).to.equal(@"application/json; charset=utf8");
    expect([[response headers] objectForKey:@"Test"]).to.equal(@"Value");
    expect(body).notTo.beNil();
    expect(decodedBody).to.equal(@"{\"key\":\"value\"}");
}

- (void)testEncodesJSONResponseDoesntOverideContentTypeHeader {
    CCLHTTPServerResponse *response = [CCLHTTPServerResponse JSONResponseWithStatusCode:200 headers:@{@"Content-Type": @"Value"} parameters:@{@"key": @"value"}];

    NSData *body = [response body];
    NSString *decodedBody = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];

    expect([response statusCode]).to.equal(200);
    expect([response headers]).notTo.beNil();
    expect([[response headers] objectForKey:@"Content-Type"]).to.equal(@"Value");
    expect(body).notTo.beNil();
    expect(decodedBody).to.equal(@"{\"key\":\"value\"}");
}

@end
