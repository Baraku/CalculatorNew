//
//  CalculatorBrainTest.swift
//  CalculatorNew
//
//  Created by Patrick Mumme on 12/23/15.
//  Copyright © 2015 Patrick Mumme. All rights reserved.
//

import XCTest

class CalculatorBrainTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(1==1)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            for i in 1...6 {
                _ = i*i
            }
        }
    }
    
}
