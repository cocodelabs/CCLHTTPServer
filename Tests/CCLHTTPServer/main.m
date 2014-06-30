//
//  main.m
//  CCLHTTPServer
//
//  Created by Kyle Fuller on 23/03/2014.
//  Copyright (c) 2014 Cocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CCLHTTPServer/CCLHTTPServer.h>
#import <CCLHTTPServer/CCLHTTPServerResponse.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        CCLHTTPServer *server = [[CCLHTTPServer alloc] initWithInterface:nil port:8080 handler:^id<CCLHTTPServerResponse>(id<CCLHTTPServerRequest> request) {
            NSDictionary *headers = @{
                @"Content-Type": @"text/plain; charset=utf8",
            };

            NSData *body = [@"Hello World" dataUsingEncoding:NSUTF8StringEncoding];

            return [[CCLHTTPServerResponse alloc] initWithStatusCode:200 headers:headers body:body];
        }];

        NSLog(@"Listening on http://0.0.0.0:8080/");

        for (;;) {
            @autoreleasepool {
                if ([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]] == NO) {
                    break;
                }
            }
        }

        server = nil;
    }

    return 0;
}

