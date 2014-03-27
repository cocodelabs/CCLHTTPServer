Pod::Spec.new do |spec|
  spec.name = 'CCLHTTPServer'
  spec.version = '0.1.0'
  spec.summary = 'Simple asyncronous HTTP server'
  spec.homepage = 'https://github.com/cocodelabs/CCLHTTPServer'
  spec.source = { :git => 'https://github.com/cocodelabs/CCLHTTPServer.git', :tag => "#{spec.version}" }
  spec.license = { :type => 'BSD', :file => 'LICENSE' }
  spec.authors = { 'Kyle Fuller' => 'inbox@kylefuller.co.uk' }
  spec.social_media_url = 'https://twitter.com/kylefuller'
  spec.osx.deployment_target = '10.7'
  spec.ios.deployment_target = '5.0'
  spec.requires_arc = true

  spec.subspec 'Server' do |server_spec|
    server_spec.source_files = 'CCLHTTPServer/CCLHTTPServer{,Response}.{h,m}'
    server_spec.dependency 'CocoaAsyncSocket'
  end

  spec.subspec 'View' do |view_spec|
    view_spec.source_files = 'CCLHTTPServer/CCLHTTPView.{h,m}'
  end
end

