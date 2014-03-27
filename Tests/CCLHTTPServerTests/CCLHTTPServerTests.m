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

@end
