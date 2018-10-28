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
	public static func mnemonicString(from hexString: String, language: MnemonicLanguageType) throws -> String {
		let seedData = hexString.mnemonicData()
		// print("\(hexString.characters.count)\t\(seedData.count)")
		let hashData = seedData.sha256()
		// print(hashData.toHexString())
		let checkSum = hashData.ck_toBitArray()
		// print(checkSum)
		var seedBits = seedData.ck_toBitArray()

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
			// print(subString)

			let index = Int(strtoul(subString, nil, 2))
			mnemonic.append(words[index])
		}
		return mnemonic.joined(separator: " ")
	}

	public static func deterministicSeedString(from mnemonic: String, passphrase: String = "", language: MnemonicLanguageType) throws -> String {

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
			// print(error)
			throw error
		}
	}

	public static func generateMnemonic(strength: Int, language: MnemonicLanguageType) throws -> String {
		guard strength % 32 == 0 else {
			throw MnemonicError.invalidStrength
		}

		let count = strength / 8
		let bytes = Array<UInt8>(repeating: 0, count: count)
		let status = SecRandomCopyBytes(kSecRandomDefault, count, UnsafeMutablePointer<UInt8>(mutating: bytes))
		// print(status)
		if status != -1 {
			let data = Data(bytes: bytes)
			let hexString = data.toHexString()
			// print(hexString)

			return try mnemonicString(from: hexString, language: language)
		}
		throw MnemonicError.unableToGetRandomData
	}
}
