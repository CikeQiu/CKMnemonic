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
			let language: CKMnemonicLanguageType = .chinese
//			let mnemonic = try CKMnemonic.generateMnemonic(strength: 128, language: language)
			let mnemonicC = try CKMnemonic.mnemonicString(from: "7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f", language: language)
			let mnemonicE = try CKMnemonic.mnemonicString(from: "7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f", language: .english)
			let seedC = try CKMnemonic.deterministicSeedString(from: mnemonicC, passphrase: "Test", language: language)
			let seedE = try CKMnemonic.deterministicSeedString(from: mnemonicE, passphrase: "Test", language: .english)
//			let seedNoSec = try CKMnemonic.deterministicSeedString(from: mnemonic, language: language)
//			print(seedNoSec)
			print(mnemonicC)
			print(mnemonicE)
			print(seedC)
			print(seedE)
		} catch {
			print(error)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

