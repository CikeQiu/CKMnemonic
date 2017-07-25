//
//  ViewController.swift
//  CKMnemonic
//
//  Created by 仇弘扬 on 2017/7/25.
//  Copyright © 2017年 askcoin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		do {
//			let mnemonic = try CKMnemonic.generateMnemonic(strength: 128, language: .english)
			let mnemonic = try CKMnemonic.mnemonicString(from: "994fe657cc35757e7256812ff2791249", language: .english)
			let seed = CKMnemonic.deterministicSeedString(from: mnemonic, passphrase: "Test", language: .english)
			let seedNoSec = CKMnemonic.deterministicSeedString(from: mnemonic, language: .english)
			print(seed)
			print(seedNoSec)
			print(mnemonic)
		} catch {
			print(error)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

