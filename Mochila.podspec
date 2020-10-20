#
# Be sure to run `pod lib lint Mochila.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Mochila'
  s.version          = '1.2'
  s.summary          = 'Tools To Speed Up Your App Development'
  s.description      = <<-DESC
                        Currently includes
                        * Layout
                        * NibView
                        * Color & Image
                        * Regex
                        * Codable
                        * Date & Number
                       DESC

  s.homepage         = 'https://github.com/Mao-Xi/Mochila'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Victor Zhu' => 'ghoyelo@gmail.com' }
  s.source           = { :git => 'https://github.com/Mao-Xi/Mochila.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['4.0', '4.1', '4.2', '5.0', '5.1', '5.2']
  s.source_files = "Mochila/**/*.swift"

end
