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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //To check the URL used for API call
    func testCheckAPIWithExpectedURL() {
        let apiCallHandler = APIHelper.shared
        let headers = ["Content-Type": "application/json"]
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts, headers: headers) { (status, data, message) in}
        XCTAssertEqual(apiCallHandler.request.url?.absoluteString, APIs.facts)
    }
    
    //To check the reponse from server
    func testAPIResponseCode() {
        let apiCallHandler = APIHelper.shared
        let headers = ["Content-Type": "application/json"]
        let responseExpectation = expectation(description: "error")
        var resonseReceived = false
        guard let internetStatus : Bool = Reachability()?.isReachable, internetStatus else{
            XCTFail("Internet connection is not available")
            return
        }
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts, headers: headers) { (status, data, message) in
            if status{
                resonseReceived = true
                responseExpectation.fulfill()
            }
        }
        wait(for: [responseExpectation], timeout: TimeInterval.init(2.0))
        XCTAssertTrue(resonseReceived)
    }
    
    //To check the facts title in API reponse.
    func testAPIReturingingTitle() {
        let apiCallHandler = APIHelper.shared
        let headers = ["Content-Type": "application/json"]
        let responseExpectation = expectation(description: "error")
        var viewTitle : String?
        guard let internetStatus : Bool = Reachability()?.isReachable, internetStatus else{
            XCTFail("Internet connection is not available")
            return
        }
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts, headers: headers) { (status, data, message) in
            if status{
                if let facts : Facts = try? JSONDecoder().decode(Facts.self, from: data!){
                    viewTitle = facts.title
                }
                responseExpectation.fulfill()
            }
        }
        wait(for: [responseExpectation], timeout: TimeInterval.init(2.0))
        XCTAssertNotNil(viewTitle, "View title should return by API")
    }
    
    //To check the facts row response returning by API
    func testAPIReturingFactsRows() {
        let apiCallHandler = APIHelper.shared
        let headers = ["Content-Type": "application/json"]
        let errorExpectation = expectation(description: "error")
        var factsRows : [Rows]?
        guard let internetStatus : Bool = Reachability()?.isReachable, internetStatus else{
            XCTFail("Internet connection is not available")
            return
        }
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts, headers: headers) { (status, data, message) in
            if status{
                if let facts : Facts = try? JSONDecoder().decode(Facts.self, from: data!){
                    factsRows = facts.rows
                }
                errorExpectation.fulfill()
            }
        }
        wait(for: [errorExpectation], timeout: TimeInterval.init(2.0))
        XCTAssertNotNil(factsRows, "facts rows should return by API")
        XCTAssertTrue((factsRows?.count ?? 0)>0, "facts data contained 1 or more then one facts")
    }
    
    //To check expected facts number rows return from API call.
    func testAPIReturingExpectedFacrsRows() {
        let apiCallHandler = APIHelper.shared
        let headers = ["Content-Type": "application/json"]
        let errorExpectation = expectation(description: "error")
        var factsRows : [Rows]?
        guard let internetStatus : Bool = Reachability()?.isReachable, internetStatus else{
            XCTFail("Internet connection is not available")
            return
        }
        apiCallHandler.codableGetRequestWith(apiName: APIs.facts, headers: headers) { (status, data, message) in
            if status{
                if let facts : Facts = try? JSONDecoder().decode(Facts.self, from: data!){
                    factsRows = facts.rows
                }
                errorExpectation.fulfill()
            }
        }
        wait(for: [errorExpectation], timeout: TimeInterval.init(2.0))
        XCTAssertTrue((factsRows?.count ?? 0) == 14, "API not returned expected records 14")
    }
}
