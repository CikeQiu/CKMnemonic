// Copyright Keefer Taylor, 2018

import MnemonicKit
import XCTest

class MnemonicTests: XCTestCase {
  // Indices in the input file.
  private let hexRepresentationIndex = 0
  private let mnenomicStringIndex = 1
  private let deterministicSeedStringIndex = 2

  // Named arrays in the test file
  private let englishTestCases = "english"

  // Passphrase
  private let passphrase = "TREZOR"

  /**
   * Test that MnemonicKit can generate mnemonic strings from hex representations.
   */
  func testGenerateMnemonicFromHex() {
    guard let vectors = MnemonicTests.dictionaryFromTestInputFile(),
      let testCases = vectors[englishTestCases] as? Array<Array<String>> else {
      XCTFail("Failed to parse input file.")
      return
    }

    for testCase in testCases {
      let expectedMnemonicString = testCase[mnenomicStringIndex]
      let hexRepresentation = testCase[hexRepresentationIndex]
      let mnemonicString = Mnemonic.mnemonicString(from: hexRepresentation)

      XCTAssertEqual(mnemonicString, expectedMnemonicString)
    }
  }

  /**
   * Test that MnemonicKit can generate deterministic seed strings strings without a passphrase.
   */
  func testGenerateDeterministicSeedStringWithPassphrase() {
    guard let vectors = MnemonicTests.dictionaryFromTestInputFile(),
      let testCases = vectors[englishTestCases] as? Array<Array<String>> else {
      XCTFail("Failed to parse input file.")
      return
    }

    for testCase in testCases {
      let mnemonicString = testCase[mnenomicStringIndex]
      let expectedDeterministicSeedString = testCase[deterministicSeedStringIndex]

      let deterministicSeedString = Mnemonic.deterministicSeedString(from: mnemonicString,
                                                                     passphrase: passphrase)
      XCTAssertEqual(deterministicSeedString, expectedDeterministicSeedString)
    }
  }

  private static func dictionaryFromTestInputFile() -> [String: Any]? {
    let testBundle = Bundle(for: self)
    guard let url = testBundle.url(forResource: "vectors", withExtension: "json") else {
      return nil
    }

    do {
      let data = try Data(contentsOf: url)
      let parsedDictionary =
        try JSONSerialization.jsonObject(with: data,
                                         options: [.allowFragments, .mutableContainers, .mutableLeaves]) as! [String: Any]

      return parsedDictionary
    } catch {
      return nil
    }
  }

  /** Test mnemonic generation in english. */
  public func testGenerateMnemonic() {
    let mnemonic = Mnemonic.generateMnemonic(strength: 32)
    XCTAssertNotNil(mnemonic)
  }

  /** Prove that functions work in chinese as well. */
  public func testGenerateMnemonicChinese() {
    let chineseMnemonic = Mnemonic.generateMnemonic(strength: 32, language: .chinese)
    XCTAssertNotNil(chineseMnemonic)
  }

  /** Test input strengths for mnemonic generation. */
  public func testMnemonicGenerationStrength() {
    let mnemonic32 = Mnemonic.generateMnemonic(strength: 32)
    let mnemonic64 = Mnemonic.generateMnemonic(strength: 32)
    XCTAssertNotNil(mnemonic32)
    XCTAssertNotNil(mnemonic64)

    let mnemonic16 = Mnemonic.generateMnemonic(strength: 32)
    XCTAssertNotNil(mnemonic16)
  }

  /** Test valid chinese and english mnemonics are determined to be valid. */
  public func testValidEnglishAndChineseMnemonics() {
    let englishMnemonic = "pear peasant pelican pen pear peasant pelican pen pear peasant pelican pen pear peasant pelican pen"
    let chineseMnemonic = "路 级 少 图 路 级 少 图 路 级 少 图 路 级 少 图"

    XCTAssertTrue(Mnemonic.validate(mnemonic: englishMnemonic))
    XCTAssertTrue(Mnemonic.validate(mnemonic: chineseMnemonic))
  }

  /** Test invalid chinese and english mnemonics are determined to be invalid. */
  public func testInvalidEnglishAndChineseMnemonics() {
    let englishMnemonic = "slacktivist snacktivity snuggie"
    let chineseMnemonic = "亂 語"

    XCTAssertFalse(Mnemonic.validate(mnemonic: englishMnemonic))
    XCTAssertFalse(Mnemonic.validate(mnemonic: chineseMnemonic))
  }

  /** Test the empty string is determined to be an invalid mnemonic. */
  public func testEmptyStringValidation() {
    XCTAssertFalse(Mnemonic.validate(mnemonic: ""))
  }

  /** Test that strings in an unknown language are determined to be invalid. */
  public func testUnknownLanguageValidation() {
    let spanishMnemonic = "pera campesina pelican pen pera campesina pelican pen pera campesina pelican pen pera campesina pelican pen"
    XCTAssertFalse(Mnemonic.validate(mnemonic: spanishMnemonic))
  }

  /** Test that strings of mixed case are determined to be valid. */
  public func testMixedCaseValidation() {
    let mixedCaseMnemonic = "pear PEASANT PeLiCaN pen"
    XCTAssertTrue(Mnemonic.validate(mnemonic: mixedCaseMnemonic))
  }

  /** Test mixed language mnemonics. */
  public func testMixedLanguageMnemonicValidation() {
    let mixedLanguageMnemonic = "pear peasant pelican pen 路 级 少 图"
    XCTAssertFalse(Mnemonic.validate(mnemonic: mixedLanguageMnemonic))
  }

  /** Test that strings padded with whitespace are determined to be valid. */
  public func testWhitespacePaddedValidation() {
    let whitespacePaddedMnemonic = "    pear peasant pelican pen\t\t\n"
    XCTAssertTrue(Mnemonic.validate(mnemonic: whitespacePaddedMnemonic))
  }
}
