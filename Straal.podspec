#
#  Be sure to run `pod spec lint Straal.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Straal"
  s.version      = "0.6.1"
  s.summary      = "A brilliant payment solution for disruptive businesses."

  s.description  =  <<-DESC
  Straal for iOS is a helper library to make it easier
  to make API requests directly from merchant's mobile iOS App.
  It utilizes client-side encryption and sends data
  over HTTPS to make secure requests creating transactions and adding cards.
                       DESC
  s.homepage     = "https://straal.com/"
  s.social_media_url  = 'https://twitter.com/straal_'

  s.license      = { :type => "Apache License, Version 2.0" }

  s.author       = { "Straal" => "devteam@straal.com" }

  s.platform     = :ios, "13.0"
  s.swift_version = '5.3'
  s.source       = { :git => "https://github.com/straal/straal-ios.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/Straal/**/*.swift"

  s.dependency "IDZSwiftCommonCrypto"
end
