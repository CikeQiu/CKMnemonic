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

  func testCreateMnemonic() {
    guard let vectors = MnemonicTests.dictionaryFromTestInputFile(),
          let testCases = vectors[englishTestCases] as? Array<Array<String>> else {
      XCTFail("Failed to parse input file.")
      return
    }

    // TODO: Don't use a throwing API here.
    for testCase in testCases {
      let expectedMnemonicString = testCase[mnenomicStringIndex]
      let expectedDeterministicSeedString = testCase[deterministicSeedStringIndex]

      let hexRepresentation = testCase[hexRepresentationIndex]
      let mnemonicString = try! Mnemonic.mnemonicString(from: hexRepresentation, language: .english)
      let deterministicSeedString = try! Mnemonic.deterministicSeedString(from: mnemonicString,
                                                                          passphrase: passphrase,
                                                                          language: .english)

      XCTAssertEqual(mnemonicString, expectedMnemonicString)
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
}
