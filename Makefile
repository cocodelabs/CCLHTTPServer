all: test-osx test-podspec

test-osx:
	xcodebuild -workspace Tests/CCLHTTPServer.xcworkspace -scheme 'CCLHTTPServer' test | xcpretty -c ; exit ${PIPESTATUS[0]}

test-podspec:
	pod lib lint CCLHTTPServer.podspec


