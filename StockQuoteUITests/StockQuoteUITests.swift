//
//  StockQuoteUITests.swift
//  StockQuoteUITests
//
//  Created by Vishwak on 23/02/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import XCTest
@testable import StockQuote

class StockQuoteUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAppNavigation() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    
        // Assert that ListTableView exists
        var tableView = app.tables["ListTableView"]
        XCTAssertTrue(tableView.exists, "The list tableview exists")
        
        //Scroll the table view until Apple cell is visible
        while !app.staticTexts["AAPL"].exists {
            tableView.swipeUp()
        }
        
        //Tapping on Apple cell, will navigate to detail screen
        tableView.staticTexts["AAPL"].tap()

        // Assert that DetailTableView exists
        var detailTableView = app.tables["DetailTableView"]
        XCTAssertTrue(detailTableView.exists, "The detail tableview exists")

        //Wait until data loads
        waitUntilExpectationGetsTrue("Fundamental", element:detailTableView)

        //Go back to list screen
        app.navigationBars["AAPL"].buttons["Stock Quotes"].tap()

        // Assert that ListTableView exists
        tableView = app.tables["ListTableView"]
        XCTAssertTrue(tableView.exists, "The list tableview exists")
        
        //Scroll the table view until Google cell is visible
        while !app.staticTexts["GOOG"].exists {
            tableView.swipeUp()
        }
        
        //Tapping on Google cell, will navigate to detail screen
        tableView.staticTexts["GOOG"].tap()
        
        // Assert that DetailTableView exists
        detailTableView = app.tables["DetailTableView"]
        XCTAssertTrue(detailTableView.exists, "The detail tableview exists")
        
        //Wait until data loads
        waitUntilExpectationGetsTrue("Fundamental", element:detailTableView)
        
        //Go back to list screen
        app.navigationBars["GOOG"].buttons["Stock Quotes"].tap()
    }
    
    func waitUntilExpectationGetsTrue(_ string: String, element:XCUIElement) {
        let predicate = NSPredicate(format: "exists == 1")
        let query = element.staticTexts[string]
        expectation(for: predicate, evaluatedWith: query, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
    }
    
}
