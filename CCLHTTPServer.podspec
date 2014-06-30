Pod::Spec.new do |spec|
  spec.name = 'CCLHTTPServer'
  spec.version = '0.9.0'
  spec.summary = 'Simple asyncronous HTTP server'
  spec.homepage = 'https://github.com/cocodelabs/CCLHTTPServer'
  spec.source = { :git => 'https://github.com/cocodelabs/CCLHTTPServer.git', :tag => "#{spec.version}" }
  spec.license = { :type => 'BSD', :file => 'LICENSE' }
  spec.authors = { 'Kyle Fuller' => 'inbox@kylefuller.co.uk' }
  spec.social_media_url = 'https://twitter.com/kylefuller'
  spec.osx.deployment_target = '10.7'
  spec.ios.deployment_target = '5.0'
  spec.requires_arc = true

  spec.subspec 'Interface' do |interface_spec|
    interface_spec.source_files = 'CCLHTTPServer/CCLHTTPServerInterface.{h,m}'
  end

  spec.subspec 'Response' do |response_spec|
    response_spec.source_files = 'CCLHTTPServer/CCLHTTPServerResponse.{h,m}'
    response_spec.dependency 'CCLHTTPServer/Interface'
  end

  spec.subspec 'Server' do |server_spec|
    server_spec.source_files = 'CCLHTTPServer/CCLHTTPServer.{h,m}'
    server_spec.dependency 'CocoaAsyncSocket'
    server_spec.dependency 'CCLHTTPServer/Interface'
    server_spec.dependency 'CCLHTTPServer/Response'
  end

  spec.subspec 'View' do |view_spec|
    view_spec.source_files = 'CCLHTTPServer/CCLHTTPView.{h,m}'
    view_spec.dependency 'CCLHTTPServer/Interface'
    view_spec.dependency 'CCLHTTPServer/Response'
  end
end

