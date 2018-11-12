# MnemonicKit  &nbsp;&nbsp;&nbsp; [![Build Status](https://travis-ci.org/keefertaylor/MnemonicKit.svg?branch=master)](https://travis-ci.org/keefertaylor/MnemonicKit) &nbsp;&nbsp;&nbsp;  [![codecov](https://codecov.io/gh/keefertaylor/MnemonicKit/branch/master/graph/badge.svg)](https://codecov.io/gh/keefertaylor/MnemonicKit)
An implementation of BIP39 in Swift. MnemonicKit supports both English and Chinese mnemonics.

This library is a fork of (CKMnemonic)[https://github.com/CikeQiu/CKMnemonic]. This fork provides several conveniences over the original library, namely: 
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

I am happy to accept pull requests. If anyone is able to reach the original authors of CKMnemonic, I am happy to merge this library upstream with them.

## License

MIT
