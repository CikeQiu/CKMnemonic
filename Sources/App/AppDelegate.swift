// Copyright Keefer Taylor, 2018

import UIKit
import MnemonicKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let viewController = ViewController()

    let window = UIWindow()
    window.rootViewController = viewController
    self.window = window
    window.makeKeyAndVisible()

    if let mnemonic = Mnemonic.generateMnemonic(strength: 64) {
      let alert = UIAlertController(title: "Generated Mnemonic", message: mnemonic, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
      viewController.present(alert, animated: true, completion: nil)
    }

    return true
  }
}
