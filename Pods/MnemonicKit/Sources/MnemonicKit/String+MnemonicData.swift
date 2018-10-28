import Foundation

public extension String {
	public func mnemonicData() -> Data {
		let length = characters.count
		let dataLength = length / 2
		var dataToReturn = Data(capacity: dataLength)

		var index = 0
		var chars = ""
		for char in characters {
			chars += String(char)
			if index % 2 == 1 {
				let i: UInt8 = UInt8(strtoul(chars, nil, 16))
				dataToReturn.append(i)
				chars = ""
			}
			index += 1
		}

		return dataToReturn
	}
}
