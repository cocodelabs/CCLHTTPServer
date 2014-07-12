CCLHTTPServer
=============

[![Build Status](http://img.shields.io/travis/cocodelabs/CCLHTTPServer.svg?style=flat)](https://travis-ci.org/cocodelabs/CCLHTTPServer)

CCLHTTPServer is a simple HTTP library server for iOS and OS X.

## Usage

You can create a basic HTTP server listening on a port using the
`CCLHTTPServer` class, simply pass it a handler and it will start listening.

```objective-c
CCLHTTPServer *server = [[CCLHTTPServer alloc] initWithInterface:nil port:8080 handler:^id<CCLHTTPServerResponse>(id<CCLHTTPServerRequest> request) {
    NSDictionary *headers = @{
        @"Content-Type": @"text/plain; charset=utf8",
    };

    NSData *body = [@"Hello World" dataUsingEncoding:NSUTF8StringEncoding];

    return [[CCLHTTPServerResponse alloc] initWithStatusCode:200 headers:headers body:body];
}];
```

Your handler will accept a request conforming to the `CCLHTTPServerRequest`
protocol. You must return an object which conforms to the
`CCLHTTPServerResponse` protocol, we've provided a standard response class
called `CCLHTTPServerResponse` which has various convinience methods for
creating responses of different types.

CCLHTTPServer was designed to expose a standard interface for creating a HTTP
server in Objective-C though the `CCLHTTPServer/Interface` pod. This means that
other HTTP servers are able to follow the same interface and allows developers
to write frameworks around this standard interface without being tied down to a
single server implementation.

### Requests

A request is an object conforming to the `CCLHTTPServerRequest` protocol which
exposes basic information about the request such as the `method`, `path`,
`HTTPVersion`, `headers` and the `body`.

```objective-c
@protocol CCLHTTPServerRequest <NSObject>
- (NSString *)method;
- (NSString *)path;
- (NSString *)HTTPVersion;
- (NSDictionary *)headers;
- (NSData *)body;
@end
```

### Responses

You can make your own response class or make an existing class conform to the
`CCLHTTPServerResponse` protcol. However for most cases you can use
`CCLHTTPServerResponse` class.

#### Response with data

```objective-c
[CCLHTTPServerResponse responseWithStatusCode:204 headers:nil body:nil];
```

#### Text response

```objective-c
[CCLHTTPServerResponse responseWithStatusCode:200
                                      headers:nil
                                      content:@"Hello World"
                                  contentType:@"plain/text"];
```

#### Form encoded response

```objective-c
[CCLHTTPServerResponse formURLEncodedResponseWithStatusCode:200
                                                    headers:nil
                                                 parameters:@{@"name": @"Kyle"}];
```

#### JSON response

```objective-c
[CCLHTTPServerResponse JSONResponseWithStatusCode:200
                                          headers:nil
                                       parameters:@{@"name": @"Kyle"}];
```

## Installation

### Podfile

```ruby
pod 'CCLHTTPServer'
```

## License

CCLHTTPServer is released under the BSD license. See [LICENSE](LICENSE).

