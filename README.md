# MnemonicKit
[![Build Status](https://travis-ci.org/keefertaylor/MnemonicKit.svg?branch=master)](https://travis-ci.org/keefertaylor/MnemonicKit)
[![codecov](https://codecov.io/gh/keefertaylor/MnemonicKit/branch/master/graph/badge.svg)](https://codecov.io/gh/keefertaylor/MnemonicKit)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/MnemonicKit.svg?style=flat)](http://cocoapods.org/pods/MnemonicKit)
[![License](https://img.shields.io/cocoapods/l/MnemonicKit.svg?style=flat)](http://cocoapods.org/pods/MnemonicKit)

An implementation of BIP39 in Swift. MnemonicKit supports both English and Chinese mnemonics.

This library is a fork of [CKMnemonic](https://github.com/CikeQiu/CKMnemonic). This fork provides several conveniences over the original library, namely:
- Converting throwing APIs to non-throwing nullable APIs
- Additional helper methods
- Code clarity and documentation
- Additional Testing
- Support on OSX

## Installation

### CocoaPods
TezosKit supports installation via CocoaPods. You can depened on MnemonicKit by adding the following to your Podfile:

```
pod "MnemonicKit"
```

#### Carthage

If you use [Carthage](https://github.com/Carthage/Carthage) to manage your dependencies, simply add
MnemonicKit to your `Cartfile`:

```
github "keefertaylor/MnemonicKit"
```

If you use Carthage to build your dependencies, make sure you have added `CryptoSwift.framework` to the "_Linked Frameworks and Libraries_" section of your target, and have included them in your Carthage framework copying build phase.


## Usage

### Generate a Mnemonic

```swift
  let englishMnemonic = Mnemonic.generateMnemonic(strength: 64, language: .english)
  let chineseMnemonic = Mnemonic.generateMnemonic(strength: 128, language: .chinese)
```


### Generate a Mnemonic from a Hex Representation

```swift
  let hexRepresentation: String = ...
  let mnemonic = Mnemonic.mnemonicString(from: hexRepresentation)
  print("Mnemonic: \(mnemonic)\nFrom hex string: \(hexRepresentation)")
```

### Generate a Seed String

```swift
  let englishMnemonic = Mnemonic.generateMnemonic(strength: 64, language: .english)
  let passphrase: String = ...
  let deterministicSeedString = Mnemonic.deterministicSeedString(from: mnemonicString,
                                                                 passphrase: passphrase,
                                                                 language: .english)
  print("Deterministic Seed String: \(deterministicSeedString)")
```

## Contributions

I am happy to accept pull requests.

To get set up:
```shell
$ brew install xcodegen # if you don't already have it
$ xcodegen generate # Generate an XCode project from Project.yml
$ open MnemonicKit.xcodeproj
```

## License

MIT
