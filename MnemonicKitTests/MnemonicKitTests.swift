import XCTest
import MnemonicKit

class CKMnemonicTests: XCTestCase {

  func testMnemonicCreate() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    guard let url = Bundle.main.url(forResource: "vectors", withExtension: "json") else {
      XCTFail("获取测试文件路径失败")
      return
    }

    do {
      let data = try Data(contentsOf: url)
      let vectors: [String: Any] = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, .mutableContainers, .mutableLeaves]) as! [String: Any]

      if let cases: Array<Array<String>> = vectors["english"] as? Array<Array<String>> {
        for test in cases {
          let selfM = try Mnemonic.mnemonicString(from: test[0], language: .english)
          let m = test[1]
          XCTAssertTrue(selfM == m, "计算出的助记词没有通过测试")

          let selfSeed = try Mnemonic.deterministicSeedString(from: selfM, passphrase: "TREZOR", language: .english)
          let seed = test[2]
          XCTAssertTrue(selfSeed == seed, "计算出的 seed 没有通过测试")
        }
      }
    } catch {
      XCTFail("测试未通过，原因：\(error)")
    }

  }
}
