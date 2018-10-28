import Foundation
import CryptoSwift
import Security

public enum MnemonicLanguageType {
	case english
	case chinese

	func words() -> [String] {
		switch self {
		case .english:
			return String.englishMnemonics
		case .chinese:
			return String.chineseMnemonics
		}
	}
}

enum MnemonicError: Error {
	case invalidStrength
	case unableToGetRandomData
	case unableToCreateSeedData
}

public class Mnemonic: NSObject {

  /**
   * Generate a mnemonic from the given hex string in the given language.
   *
   * @param hexString The hex string to generate a mnemonic from.
   * @param language The language to use. Default is english.
   */
	public static func mnemonicString(from hexString: String,
                                    language: MnemonicLanguageType = .english) -> String? {
		let seedData = hexString.mnemonicData()
		let hashData = seedData.sha256()
		let checkSum = hashData.toBitArray()
		var seedBits = seedData.toBitArray()

		for i in 0..<seedBits.count / 32 {
			seedBits.append(checkSum[i])
		}

		let words = language.words()

		let mnemonicCount = seedBits.count / 11
		var mnemonic = [String]()
		for i in 0..<mnemonicCount {
			let length = 11
			let startIndex = i * length
			let subArray = seedBits[startIndex..<startIndex + length]
			let subString = subArray.joined(separator: "")

			let index = Int(strtoul(subString, nil, 2))
			mnemonic.append(words[index])
		}
		return mnemonic.joined(separator: " ")
	}

  /**
   * Generate a deterministic seed string from the given inputs.
   *
   * @param mnemonic The mnemonic to use.
   * @param passphrase An optional passphrase. Default is the empty string.
   * @param language The language to use. Default is english.
   */
	public static func deterministicSeedString(from mnemonic: String,
                                             passphrase: String = "",
                                             language: MnemonicLanguageType = .english) throws -> String {
		func normalized(string: String) -> Data? {
			guard let data = string.data(using: .utf8, allowLossyConversion: true) else {
				return nil
			}

			guard let dataString = String(data: data, encoding: .utf8) else {
				return nil
			}

			guard let normalizedData = dataString.data(using: .utf8, allowLossyConversion: false) else {
				return nil
			}
			return normalizedData
		}

		guard let normalizedData = normalized(string: mnemonic) else {
			return ""
		}

		guard let saltData = normalized(string: "mnemonic" + passphrase) else {
			return ""
		}

		let password = normalizedData.bytes
		let salt = saltData.bytes

		do {
			let bytes = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 2048, variant: .sha512).calculate()

			return bytes.toHexString()
		} catch {
			throw error
		}
	}

  /**
   * Generate a mnemonic of the given strength and given language.
   *
   * @param strength The strength to use. This must be a multiple of 32.
   * @param language The language to use. Default is english.
   */
	public static func generateMnemonic(strength: Int, language: MnemonicLanguageType = .english)
      -> String? {
		guard strength % 32 == 0 else {
      return nil
    }

		let count = strength / 8
		let bytes = Array<UInt8>(repeating: 0, count: count)
    guard SecRandomCopyBytes(kSecRandomDefault, count, UnsafeMutablePointer<UInt8>(mutating: bytes)) != -1 else {
      return nil
    }
    let data = Data(bytes: bytes)
    let hexString = data.toHexString()
    do {
      return try mnemonicString(from: hexString, language: language)
    } catch {
      return nil
    }
	}
}
