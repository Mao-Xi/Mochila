#
# Be sure to run `pod lib lint Mochila.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Mochila'
  s.version          = '0.1.0'
  s.summary          = 'Tools To Speed Up Your App Development'
  s.description      = <<-DESC
                        Currently includes
                        *
                        *
                        *
                       DESC

  s.homepage         = 'https://github.com/Mao-Xi/Mochila'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Victor Zhu' => 'ghoyelo@gmail.com' }
  s.source           = { :git => 'https://github.com/Mao-Xi/Mochila.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['4.0', '4.1', '4.2', '5.0', '5.1', '5.2']

  s.default_subspecs = %w[Core]

  s.subspec "Core" do |s|
    s.source_files = "Mochila/Core/*.swift"
  end

  s.subspec "Layout" do |s|
    s.dependency "Mochila/Core"
    s.source_files = "Mochila/Layout/*.swift"
  end

end
