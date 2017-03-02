#
# Be sure to run `pod lib lint RxGmail.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxGmail'
  s.version          = '0.1.0'
  s.summary          = 'A library for accessing the Gmail API using RxSwift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This library provides RxSwift Observables for accessing the Gmail API (https://developers.google.com/gmail/api/). Using Observables replaces the use of callbacks and transparently handles API calls that require paging.
                       DESC

  s.homepage         = 'https://github.com/Andy Chou/RxGmail'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andy Chou' => 'acchou4@gmail.com' }
  s.source           = { :git => 'https://github.com/Andy Chou/RxGmail.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'RxGmail/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RxGmail' => ['RxGmail/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'RxSwift', '~> 3.2'
  s.dependency 'RxSwiftExt', '~> 2.1'
  s.dependency 'GoogleAPIClientForREST/Gmail'
end
