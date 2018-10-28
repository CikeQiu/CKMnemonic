import XCTest
import MnemonicKit

class MnemonicTests: XCTestCase {

  func testCreateMnemonic() {
    guard let vectors = MnemonicTests.dictionaryFromTestInputFile() else {
      XCTFail("Failed to parse test input file.")
      return
    }

    if let cases: Array<Array<String>> = vectors["english"] as? Array<Array<String>> {
      for test in cases {
        // TODO: Don't use a throwing API here.
        // TODO: Change errors to english
        // TODO: Use named constants for test array rather than magic numbers
        let selfM = try! Mnemonic.mnemonicString(from: test[0], language: .english)
        let m = test[1]
        XCTAssertTrue(selfM == m, "计算出的助记词没有通过测试")

        let selfSeed = try! Mnemonic.deterministicSeedString(from: selfM, passphrase: "TREZOR", language: .english)
        let seed = test[2]
        XCTAssertTrue(selfSeed == seed, "计算出的 seed 没有通过测试")
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
