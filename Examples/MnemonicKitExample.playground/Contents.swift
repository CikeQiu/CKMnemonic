// Copyright Keefer Taylor, 2019

import MnemonicKit

let strength = 128
if let mnemonic = Mnemonic.generateMnemonic(strength: strength) {
  print("A mnemonic of strength \(strength): \(mnemonic)")
}
