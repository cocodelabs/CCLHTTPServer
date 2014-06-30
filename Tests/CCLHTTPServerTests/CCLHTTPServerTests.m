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

#pragma mark - Content

- (void)testEncodesTextResponse {
    CCLHTTPServerResponse *response = [CCLHTTPServerResponse responseWithStatusCode:200 headers:nil content:@"Hello World 👌!" contentType:@"text/plain"];

    NSData *body = [response body];
    NSString *decodedBody = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];

    expect([response statusCode]).to.equal(200);
    expect([response headers]).notTo.beNil();
    expect([[response headers] objectForKey:@"Content-Type"]).to.equal(@"text/plain; charset=utf8");
    expect(body).notTo.beNil();
    expect(decodedBody).to.equal(@"Hello World 👌!");
}

- (void)testEncodesTextResponseWithExistingHeaders {
    CCLHTTPServerResponse *response = [CCLHTTPServerResponse responseWithStatusCode:200 headers:@{@"Foo": @"Bar"} content:@"Hello World 👌!" contentType:@"text/plain"];

    NSData *body = [response body];
    NSString *decodedBody = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];

    expect([response statusCode]).to.equal(200);
    expect([response headers]).notTo.beNil();
    expect([response headers]).to.equal(@{@"Content-Type": @"text/plain; charset=utf8", @"Foo": @"Bar"});
    expect(body).notTo.beNil();
    expect(decodedBody).to.equal(@"Hello World 👌!");
}

#pragma mark - JSON

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

#pragma mark - Property List

- (void)testEncodesPropertyListResponse {
    CCLHTTPServerResponse *response = [CCLHTTPServerResponse propertyListResponseWithStatusCode:200 headers:nil plist:@{@"key": @"value"}];

    NSData *body = [response body];
    id plist = [NSPropertyListSerialization propertyListWithData:body options:NSPropertyListImmutable format:NULL error:nil];

    expect([response statusCode]).to.equal(200);
    expect([response headers]).notTo.beNil();
    expect([[response headers] objectForKey:@"Content-Type"]).to.equal(@"application/x-plist; charset=utf8");
    expect(body).notTo.beNil();
    expect(plist).to.equal(@{@"key": @"value"});
}

- (void)testEncodesPropertyListResponseDoesntOverideHeaders {
    CCLHTTPServerResponse *response = [CCLHTTPServerResponse propertyListResponseWithStatusCode:200 headers:@{@"Test": @"Value"} plist:@{@"key": @"value"}];

    NSData *body = [response body];
    id plist = [NSPropertyListSerialization propertyListWithData:body options:NSPropertyListImmutable format:NULL error:nil];

    expect([response statusCode]).to.equal(200);
    expect([response headers]).notTo.beNil();
    expect([[response headers] objectForKey:@"Content-Type"]).to.equal(@"application/x-plist; charset=utf8");
    expect([[response headers] objectForKey:@"Test"]).to.equal(@"Value");
    expect(body).notTo.beNil();
    expect(plist).to.equal(@{@"key": @"value"});
}

- (void)testEncodesPropertyListResponseDoesntOverideContentTypeHeader {
    CCLHTTPServerResponse *response = [CCLHTTPServerResponse propertyListResponseWithStatusCode:200 headers:@{@"Content-Type": @"Value"} plist:@{@"key": @"value"}];

    NSData *body = [response body];
    id plist = [NSPropertyListSerialization propertyListWithData:body options:NSPropertyListImmutable format:NULL error:nil];

    expect([response statusCode]).to.equal(200);
    expect([response headers]).notTo.beNil();
    expect([[response headers] objectForKey:@"Content-Type"]).to.equal(@"Value");
    expect(body).notTo.beNil();
    expect(plist).to.equal(@{@"key": @"value"});
}

#pragma mark - Form URL Encoded

- (void)testEncodesFormURLEncodedResponse {
    CCLHTTPServerResponse *response = [CCLHTTPServerResponse formURLEncodedResponseWithStatusCode:200 headers:nil dictionary:@{@"key": @"v@lue"}];

    NSData *body = [response body];
    NSString *decodedBody = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];

    expect([response statusCode]).to.equal(200);
    expect([response headers]).notTo.beNil();
    expect([[response headers] objectForKey:@"Content-Type"]).to.equal(@"application/x-www-form-urlencoded; charset=utf8");
    expect(body).notTo.beNil();
    expect(decodedBody).to.equal(@"key=v%40lue");
}

- (void)testEncodesFormURLEncodedResponseDoesntOverideHeaders {
    CCLHTTPServerResponse *response = [CCLHTTPServerResponse formURLEncodedResponseWithStatusCode:200 headers:@{@"Test": @"Value"} dictionary:@{@"key": @"v@lue"}];

    NSData *body = [response body];
    NSString *decodedBody = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];

    expect([response statusCode]).to.equal(200);
    expect([response headers]).notTo.beNil();
    expect([[response headers] objectForKey:@"Content-Type"]).to.equal(@"application/x-www-form-urlencoded; charset=utf8");
    expect([[response headers] objectForKey:@"Test"]).to.equal(@"Value");
    expect(body).notTo.beNil();
    expect(decodedBody).to.equal(@"key=v%40lue");
}

- (void)testEncodesFormURLEncodedResponseDoesntOverideContentTypeHeader {
    CCLHTTPServerResponse *response = [CCLHTTPServerResponse formURLEncodedResponseWithStatusCode:200 headers:@{@"Content-Type": @"Value"} dictionary:@{@"key": @"v@lue"}];

    NSData *body = [response body];
    NSString *decodedBody = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];

    expect([response statusCode]).to.equal(200);
    expect([response headers]).notTo.beNil();
    expect([[response headers] objectForKey:@"Content-Type"]).to.equal(@"Value");
    expect(body).notTo.beNil();
    expect(decodedBody).to.equal(@"key=v%40lue");
}

@end
