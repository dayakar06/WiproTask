//
//  WiproTaskTests.swift
//  WiproTaskTests
//
//  Created by Dayakar Reddy on 04/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import XCTest
@testable import WiproTask

class NetworkTests: XCTestCase {

    var apiCallHandler : APIHelper!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.apiCallHandler = APIHelper()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.apiCallHandler = nil
        super.tearDown()
    }
    
    //Used to check the URL used for API call
    func testCheckAPIWithExpectedURL() {
        if !apiCallHandler.reachability.isReachable{
            XCTFail(CustomMessages.noInternet)
            return
        }
        
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts) { (status, data, message) in}
        
        XCTAssertEqual(apiCallHandler.request.url?.absoluteString, APIs.facts, "Link should match")
    }
    
    //Used to check the reponse from server
    func testAPIResponseCode() {
        if !apiCallHandler.reachability.isReachable{
            XCTFail(CustomMessages.noInternet)
            return
        }
        
        let responseExpectation = expectation(description: "Facts reponse status")
        var resonseReceived = false
        
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts) { (status, data, message) in
            if status{
                resonseReceived = true
            }
            responseExpectation.fulfill()
        }
        wait(for: [responseExpectation], timeout: TestExpectionTime.short)
        
        XCTAssertTrue(resonseReceived, "Facts API call should receive a response")
    }
    
    //Used to check the facts title in API reponse.
    func testAPIReturningTitle() {
        if !apiCallHandler.reachability.isReachable{
            XCTFail(CustomMessages.noInternet)
            return
        }
        
        let responseExpectation = expectation(description: "Facts title")
        var viewTitle : String?
        
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts) { (status, facts, message) in
            if status{
                viewTitle = facts?.title ?? ""
                responseExpectation.fulfill()
            }
        }
        wait(for: [responseExpectation], timeout: TestExpectionTime.short)
        
        XCTAssertNotNil(viewTitle, "View title should return by API")
    }
    
    //Used to check the facts row response returning by API
    func testAPIReturingFactsRowsData() {
        if !apiCallHandler.reachability.isReachable{
            XCTFail(CustomMessages.noInternet)
            return
        }
    
        let responseExpectation = expectation(description: "Facts rows details")
        var factsRows : [Rows]?
        
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts) { (status, facts, message) in
            if status{
                factsRows = facts?.rows
                responseExpectation.fulfill()
            }
        }
        wait(for: [responseExpectation], timeout: TestExpectionTime.short)
        
        XCTAssertNotNil(factsRows, "facts rows should return by API")
        XCTAssertTrue((factsRows?.count ?? 0)>0, "facts data contained 1 or more then one facts")
    }
    
    //Used to check expected facts number rows return from API call.
    func testAPIReturingFactsRowsCount() {
        if !apiCallHandler.reachability.isReachable{
            XCTFail(CustomMessages.noInternet)
            return
        }
        
        let responseExpectation = expectation(description: "Facts rows count")
        var factsRows : [Rows]?
        
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts) { (status, facts, message) in
            if status{
                factsRows = facts?.rows
                responseExpectation.fulfill()
            }
        }
        
        wait(for: [responseExpectation], timeout: TestExpectionTime.short)
        XCTAssertTrue((factsRows?.count ?? 0) == 14, "API not returned expected records 14")
    }
}
