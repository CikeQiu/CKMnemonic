//
//  CKMnemonicTests.swift
//  CKMnemonicTests
//
//  Created by 仇弘扬 on 2017/7/25.
//  Copyright © 2017年 askcoin. All rights reserved.
//

import XCTest
@testable import CKMnemonic

class CKMnemonicTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMnemonicCreate() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		
		guard let url = Bundle.main.url(forResource: "vectors", withExtension: "json") else {
			XCTFail("获取测试文件路径失败")
			return
		}
		
		do {
			let data = try Data(contentsOf: url)
			let vectors: [String: Any] = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, .mutableContainers, .mutableLeaves]) as! [String: Any]
			print(vectors)
			if let cases: Array<Array<String>> = vectors["english"] as? Array<Array<String>> {
				for test in cases {
					let selfM = try CKMnemonic.mnemonicString(from: test[0], language: .english)
					let m = test[1]
					XCTAssertTrue(selfM == m, "计算出的助记词没有通过测试")
					
//					let seed = CKMnemonic.deterministicSeedString(from: selfM, language: .english)
				}
			}
		} catch {
			XCTFail("解析Json失败")
		}
		
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
