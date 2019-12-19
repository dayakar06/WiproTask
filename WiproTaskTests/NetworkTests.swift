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
        let headers = ["Content-Type": "application/json"]
        
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts, headers: headers) { (status, data, message) in}
        
        XCTAssertEqual(apiCallHandler.request.url?.absoluteString, APIs.facts)
    }
    
    //Used to check the reponse from server
    func testAPIResponseCode() {
        if !apiCallHandler.reachability.isReachable{
            XCTFail(CustomMessages.noInternet)
            return
        }
        let headers = ["Content-Type": "application/json"]
        let responseExpectation = expectation(description: "error")
        var resonseReceived = false
        
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts, headers: headers) { (status, data, message) in
            if status{
                resonseReceived = true
            }
            responseExpectation.fulfill()
        }
        wait(for: [responseExpectation], timeout: TimeInterval.init(5.0))
        
        XCTAssertTrue(resonseReceived)
    }
    
    //Used to check the facts title in API reponse.
    func testAPIReturingingTitle() {
        if !apiCallHandler.reachability.isReachable{
            XCTFail(CustomMessages.noInternet)
            return
        }
        let headers = ["Content-Type": "application/json"]
        let responseExpectation = expectation(description: "error")
        var viewTitle : String?
        
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts, headers: headers) { (status, facts, message) in
            if status{
                viewTitle = facts?.title ?? ""
                responseExpectation.fulfill()
            }
        }
        wait(for: [responseExpectation], timeout: TimeInterval.init(2.0))
        
        XCTAssertNotNil(viewTitle, "View title should return by API")
    }
    
    //Used to check the facts row response returning by API
    func testAPIReturingFactsRows() {
        if !apiCallHandler.reachability.isReachable{
            XCTFail(CustomMessages.noInternet)
            return
        }
        
        let headers = ["Content-Type": "application/json"]
        let errorExpectation = expectation(description: "error")
        var factsRows : [Rows]?
        
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts, headers: headers) { (status, facts, message) in
            if status{
                factsRows = facts?.rows
                errorExpectation.fulfill()
            }
        }
        wait(for: [errorExpectation], timeout: TimeInterval.init(2.0))
        
        XCTAssertNotNil(factsRows, "facts rows should return by API")
        XCTAssertTrue((factsRows?.count ?? 0)>0, "facts data contained 1 or more then one facts")
    }
    
    //Used to check expected facts number rows return from API call.
    func testAPIReturingExpectedFacrsRows() {
        if !apiCallHandler.reachability.isReachable{
            XCTFail(CustomMessages.noInternet)
            return
        }
        let headers = ["Content-Type": "application/json"]
        let errorExpectation = expectation(description: "error")
        var factsRows : [Rows]?
        
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts, headers: headers) { (status, facts, message) in
            if status{
                factsRows = facts?.rows
                errorExpectation.fulfill()
            }
        }
        
        wait(for: [errorExpectation], timeout: TimeInterval.init(2.0))
        XCTAssertTrue((factsRows?.count ?? 0) == 14, "API not returned expected records 14")
    }
}
