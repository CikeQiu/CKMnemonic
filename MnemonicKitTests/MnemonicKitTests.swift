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
    guard let vectors = MnemonicTests.dictionaryFromTestInputFile() else {
      XCTFail("Failed to parse test input file.")
      return
    }

    if let testCases: Array<Array<String>> = vectors[englishTestCases] as? Array<Array<String>> {
      for test in cases {
        // TODO: Don't use a throwing API here.
        let mnemonicString = try! Mnemonic.mnemonicString(from: test[hexRepresentationIndex], language: .english)
        let expectedMnemonicString = test[mnenomicStringIndex]
        XCTAssertEqual(mnemonicString, expectedMnemonicString)

        let deterministicSeedString = try! Mnemonic.deterministicSeedString(from: mnemonicString,
                                                                            passphrase: passphrase,
                                                                            language: .english)
        let expectedDeterministicSeedString = test[deterministicSeedStringIndex]
        XCTAssertEqual(deterministicSeedString, expectedDeterministicSeedString)
      }
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
