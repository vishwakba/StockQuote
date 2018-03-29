//
//  SQDataManagerTests.swift
//  StockQuoteTests
//
//  Created by Vishwak on 23/02/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import XCTest
@testable import StockQuote

class SQDataManagerTests: XCTestCase {
    
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
    }
    
    func testStockQuotesJSONFileReadingWithCorrectCount() {
        let dataManager = SQDataManager.database()
        let list = dataManager.list
        XCTAssertEqual(list.count, 3290, "Total 3290 companies should be in the list")
    }
    
    func testStockQuotesJSONFileReadingWithInCorrectCount() {
        let dataManager = SQDataManager.database()
        let list = dataManager.list
        XCTAssertNotEqual(list.count, 0, "Total 3290 companies should be in the list, not zero")
    }
    
}
