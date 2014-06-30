CCLHTTPServer
=============

[![Build Status](https://travis-ci.org/cocodelabs/CCLHTTPServer.png?branch=master)](https://travis-ci.org/cocodelabs/CCLHTTPServer)

CCLHTTPServer is a simple HTTP library server for iOS and OS X.

## Usage

```objective-c
CCLHTTPServer *server = [[CCLHTTPServer alloc] initWithInterface:nil port:8080 handler:^id<CCLHTTPServerResponse>(id<CCLHTTPServerRequest> request) {
    NSDictionary *headers = @{
        @"Content-Type": @"text/plain; charset=utf8",
    };

    NSData *body = [@"Hello World" dataUsingEncoding:NSUTF8StringEncoding];

    return [[CCLHTTPServerResponse alloc] initWithStatusCode:200 headers:headers body:body];
}];
```

## Installation

### Podfile

```ruby
pod 'CCLHTTPServer', :git => 'https://github.com/cocodelabs/CCLHTTPServer.git'
```

## License

CCLHTTPServer is released under the BSD license. See [LICENSE](LICENSE).

