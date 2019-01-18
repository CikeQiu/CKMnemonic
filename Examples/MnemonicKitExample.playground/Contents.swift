import MnemonicKit

if let mnemonic = Mnemonic.generateMnemonic(strength: 64) {
  print("Generate a mnemonic of strength 64: \(mnemonic)");
}
