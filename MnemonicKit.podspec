Pod::Spec.new do |s|
  s.name         = "MnemonicKit"
  s.version      = "1.2.0"
  s.summary      = "MnemonicKit provides a Swift implementation of BIP39"
  s.description  = <<-DESC
  MnemonicKit provides a Swift implementation of BIP39. 
  
  This library is originally forked from CKMnemonic: https://github.com/CikeQiu/CKMnemonic. Modifications are made for non-throwing APIs and support on OSX as well as iOS. Credit for most of this work is given to work_cocody@hotmail.com, qiuhongyang@askcoin.org.
                   DESC

  s.homepage     = "https://github.com/fortmarek/MnemonicKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Keefer Taylor" => "keefer@keefertaylor.com" }
  s.source       = { :git => "https://github.com/fortmarek/MnemonicKit.git", :tag => "1.2.0" }
  s.source_files  = "Sources/**/*.swift",
  s.exclude_files = "Sources/App/*.swift"
  s.swift_version = "4.2"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
		
  s.dependency "CryptoSwift", "~> 0.13.1"

  s.test_spec "Tests" do |test_spec|
    test_spec.source_files = "MnemonicKitTests/*.swift"
    test_spec.resources = ["MnemonicKitTests/*.json"]
  end  
end