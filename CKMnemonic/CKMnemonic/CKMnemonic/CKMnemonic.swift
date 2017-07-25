//
//  CKMnemonic.swift
//  Pods
//
//  Created by 仇弘扬 on 2017/7/24.
//
//

import UIKit
import CryptoSwift
import Security

enum CKMnemonicLanguageType {
	case english
	
	func words() -> [String] {
		switch self {
		case .english:
			return String.englishs
		}
	}
}

enum CKMnemonicError: Error
{
	case invalidStrength
	case unableToGetRandomData
	case unableToCreateSeedData
}

class CKMnemonic: NSObject {
	static func mnemonicString(from hexString: String, language: CKMnemonicLanguageType) throws -> String {
		let seedData = hexString.ck_mnemonicData()
		print("\(hexString.characters.count)\t\(seedData.count)")
		let hashData = seedData.sha256()
		print(hashData.toHexString())
		let checkSum = hashData.ck_toBitArray()
		print(checkSum)
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
			print(subString)
			
			let index = Int(strtoul(subString, nil, 2))
			mnemonic.append(words[index])
		}
		return mnemonic.joined(separator: " ")
	}
	
	static func deterministicSeedString(from mnemonicString: String, passphrase: String = "", language: CKMnemonicLanguageType) -> String {
		return ""
	}
	
	static func generateMnemonic(strength: Int, language: CKMnemonicLanguageType) throws -> String {
		guard strength % 32 == 0 else {
			throw CKMnemonicError.invalidStrength
		}
		
		let count = strength / 8
		let bytes = Array<UInt8>(repeating: 0, count: count)
		let status = SecRandomCopyBytes(kSecRandomDefault, count, UnsafeMutablePointer<UInt8>(mutating: bytes))
		print(status)
		if status != -1 {
			let data = Data(bytes: bytes)
			let hexString = data.toHexString()
			print(hexString)
			
			return try mnemonicString(from: hexString, language: language)
		}
		throw CKMnemonicError.unableToGetRandomData
	}
}
