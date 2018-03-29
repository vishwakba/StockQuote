//
//  SQAPIHandlerTests.swift
//  StockQuoteTests
//
//  Created by Vishwak on 23/02/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import XCTest
@testable import StockQuote

class SQAPIHandlerTests: XCTestCase {
    
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
    
    func testAuthenticateTPTOAuth2WithCorrectKeys() {
        let clientId = "OrdDb6nL8D8AiQbHEiU"
        let clientSecret = "C6ZTGSYev7UpnfOVW7KL1zTTHQ2L0i8Q4tu9f4FwyxKMC0wXhDrUC"
        let grantType = "client_credentials"
        
        let promise = expectation(description: "Access Token should be retirved")

        let apiClient = SQAPIClient.shared()
        apiClient.clientId = clientId
        apiClient.clientSecret = clientSecret
        apiClient.grantType = grantType
        
        _ = SQAPIHandler.authenticateTPTOAuth2 { (response, error) in
            if (response != nil) {
                if let code = response!["code"] {
                    if code as! String == "NOT_AUTHORIZED" {
                        XCTFail("Error: \(response!["error"] as! String)")
                    }
                } else {
                    promise.fulfill()
                }
            } else if (error != nil) {
                XCTFail("Error: \(error?.localizedDescription ?? "")")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testAuthenticateTPTOAuth2WithInCorrectKeys() {
        let clientId = "OrdDb6nL8D8AiQbHEi"
        let clientSecret = "C6ZTGSYev7UpnfOVW7KL1zTTHQ2L0i8Q4tu9f4FwyxKMC0wXhDrU"
        let grantType = "client_credentials"
        
        let promise = expectation(description: "Access Token should not be retirved, as we have provided invalid clientId and clientSecret")
        
        let apiClient = SQAPIClient.shared()
        apiClient.clientId = clientId
        apiClient.clientSecret = clientSecret
        apiClient.grantType = grantType
        
        _ = SQAPIHandler.authenticateTPTOAuth2 { (response, error) in
            if (response != nil) {
                if let code = response!["code"] {
                    if code as! String == "NOT_AUTHORIZED" {
                        promise.fulfill()
                    }
                } else {
                    XCTFail("Response: \(response ?? [:])")
                }
            } else if (error != nil) {
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchValidCompanyQuote() {
        let companySymbol = "AAPL"

        let promise = expectation(description: "Should return the company stock quote")

        _ = SQAPIHandler.fetchCompanyQuote(companySymbol) { (response, error) in
            if (response != nil) {
                promise.fulfill()
            } else if (error != nil) {
                XCTFail("Error: \(error?.localizedDescription ?? "")")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchInvalidCompanyQuote() {
        let companySymbol = "AAPL123"
        
        let promise = expectation(description: "Should not return the company stock quote, as we are sending invalid company symbol")
        
        //First authenticate with TPT OAuth2, before calling fetchCompanyQuote
        _ = SQAPIHandler.authenticateTPTOAuth2({ (response, error) in
            _ = SQAPIHandler.fetchCompanyQuote(companySymbol) { (response, error) in
                if (response != nil) {
                    if let code = response!["code"] {
                        if code as! String == "NOT_FOUND" {
                            promise.fulfill()
                        }
                    } else {
                        XCTFail("Response: \(response ?? [:])")
                    }
                } else if (error != nil) {
                    promise.fulfill()
                }
            }
        })
        
        waitForExpectations(timeout: 20, handler: nil)
    }

}
