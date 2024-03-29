#
# Be sure to run `pod lib lint NxCalendar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NxCalendar'
  s.version          = '0.1.15'
  s.summary          = 'A short description of NxCalendar.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Long descsription'

  s.homepage         = 'https://github.com/AiDco/NxCalendar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AiDco' => 'karmanov.dm@icloud.com' }
  s.source           = { :git => 'https://github.com/AiDco/NxCalendar.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.1'

  s.source_files = 'NxCalendar/Classes/**/*'

  
   s.resource_bundles = {
     'NxCalendar' => ['NxCalendar/Assets/*.png']
   }

   s.resources = 'NxCalendar/Assets/**'

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
