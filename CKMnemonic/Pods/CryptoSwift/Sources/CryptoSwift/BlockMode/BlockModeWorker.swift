//
//  BlockModeWorker.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/05/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

protocol BlockModeWorker {
    var cipherOperation: CipherOperationOnBlock { get }
    mutating func encrypt(_ plaintext: ArraySlice<UInt8>) -> Array<UInt8>
    mutating func decrypt(_ ciphertext: ArraySlice<UInt8>) -> Array<UInt8>
}
