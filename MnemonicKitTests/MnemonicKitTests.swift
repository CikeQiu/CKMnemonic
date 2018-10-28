import XCTest
import MnemonicKit

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
      let mnemonicString = try! Mnemonic.mnemonicString(from: hexRepresentation, language: .english)

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

      let deterministicSeedString = try! Mnemonic.deterministicSeedString(from: mnemonicString,
                                                                          passphrase: passphrase,
                                                                          language: .english)
      XCTAssertEqual(deterministicSeedString, expectedDeterministicSeedString)
    }
  }

  private static func dictionaryFromTestInputFile() ->  [String: Any]? {
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
}
