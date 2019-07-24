#
# Be sure to run `pod lib lint KoalaTransitions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KoalaTransitions'
  s.version          = '0.0.5'
  s.summary          = 'Provide Controller to Controller tansitions'
  s.description      = <<-DESC

Provide Controller to Controller tansitions required for KoalaMobile, replacing Hero


                       DESC

  s.homepage         = 'https://github.com/fuzz-productions/koala-transitions-iosmodule'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'nick@fuzzproductions.com' => 'Nick@Fuzzproductions.com' }
  s.source           = { :git => 'git@github.com:fuzz-productions/koala-transitions-iosmodule.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'KoalaTransitions/Classes/**/*'
  s.swift_version = '5.0'

end
