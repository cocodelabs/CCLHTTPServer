Pod::Spec.new do |spec|
  spec.name = 'CCLHTTPServer'
  spec.version = '0.1.0'
  spec.summary = 'Simple asyncronous HTTP server'
  spec.homepage = 'https://github.com/cocodelabs/CCLHTTPServer'
  spec.source = { :git => 'https://github.com/cocodelabs/CCLHTTPServer.git', :tag => "#{spec.version}" }
  spec.license = { :type => 'BSD', :file => 'LICENSE' }
  spec.authors = { 'Kyle Fuller' => 'inbox@kylefuller.co.uk' }
  spec.social_media_url = 'https://twitter.com/kylefuller'
  spec.platform = :osx, '10.7'
  spec.platform = :ios, '5.0'
  spec.source_files = 'CCLHTTPServer/*.{h,m}'
  spec.dependency 'CocoaAsyncSocket'
  spec.requires_arc = true
end

