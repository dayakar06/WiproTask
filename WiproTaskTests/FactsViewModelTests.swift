//
//  FactsViewModelTests.swift
//  WiproTaskTests
//
//  Created by Dayakar Reddy on 18/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import XCTest

@testable import WiproTask

class FactsViewModelTests: XCTestCase {

    //SUT
    var factsViewModel : FactsViewModel!
    var mockAPIHelper : MockAPIHelper!
    
    //Setting up SUT
    override func setUp() {
        super.setUp()
        self.mockAPIHelper = MockAPIHelper()
        self.factsViewModel = FactsViewModel(apiHelper: mockAPIHelper)
    }

    //removing the SUT
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.factsViewModel = nil
        self.mockAPIHelper = nil
        super.tearDown()
    }
    
    //Used to check the API call success case
    func testFetchFactsDataAPICallSuccess() {
        mockAPIHelper.facts = Facts()
        factsViewModel.fetchFactsData()
        
        XCTAssert(mockAPIHelper!.isFetchFactsDataAPICalled)
    }
    
    //Used to check the API call failing case
    func testFetchFactsDetailsAPICallFail() {
        let error = CustomMessages.defaultResponseError
        
        factsViewModel.fetchFactsData()
        mockAPIHelper.fetchFail(error: error )
        
        XCTAssertEqual(factsViewModel.alertMessage, error )
    }
    
    //Used to check the loader funtionality
    func testCheckTheLoadingStatus() {
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        factsViewModel.updateLoadingStatusClosure = { [weak self] in
            loadingStatus = self?.factsViewModel.factsApiCalling ?? false
            expect.fulfill()
        }
        
        factsViewModel.fetchFactsData()
        XCTAssertTrue( loadingStatus )
        
        mockAPIHelper!.fetchSuccess()
        XCTAssertFalse( loadingStatus )
    }
    
    //Used to check the rows count for dummy data
    func testNumberOfRowsCount() {
        let facts = loadFactsData()
        mockAPIHelper.facts = facts
        let expect = XCTestExpectation(description: "numberOfCellsCunt")
        factsViewModel.reloadTableViewClosure = { () in
            expect.fulfill()
        }
        
        factsViewModel.fetchFactsData()
        mockAPIHelper.fetchSuccess()
        
        XCTAssertEqual(factsViewModel.numberOfCells, facts.rows?.count )
        wait(for: [expect], timeout: 1.0)
        
    }
    
    //Used to check the fact title
    func testCheckFactsRowTitle() {
        self.fetchFactsFinished()
        let cellRow = 2
        
        let testPhoto = mockAPIHelper.facts.rows?[cellRow]
        let factRow = factsViewModel.valueAtIndex(cellRow)
        
        XCTAssertEqual(testPhoto?.title, factRow?.title)
    }
    
    //Used to check the fact description
    func testCheckFactsRowDescription() {
        self.fetchFactsFinished()
        let cellRow = 2
        
        let testPhoto = mockAPIHelper.facts.rows?[cellRow]
        let factRow = factsViewModel.valueAtIndex(cellRow)
        
        XCTAssertEqual(testPhoto?.description, factRow?.description)
    }
}

//Extenstion used to update/Fetch the static data from local facts data
extension FactsViewModelTests{
    func loadFactsData() -> Facts{
        guard let factsData = FactsReponse.factStringData.data(using: .utf8), let facts : Facts = try? JSONDecoder().decode(Facts.self, from: factsData) else{
            return Facts()
        }
        return facts
    }
    
    private func fetchFactsFinished() {
        mockAPIHelper.facts = loadFactsData()
        factsViewModel.fetchFactsData()
        mockAPIHelper.fetchSuccess()
    }
}


//Used to mock the API calls
class MockAPIHelper: APIHelperProtocol {
    var isFetchFactsDataAPICalled = false
    var facts: Facts!
    var completeClosure: ((Bool, Facts?, String) -> ())!
    
    func codableGetRequestWith(apiName: String, headers: [String : String]?, completionHandler: @escaping (Bool, Facts?, String) -> Void) {
        self.isFetchFactsDataAPICalled = true
        completeClosure = completionHandler
    }
    
    //Returns the success resonse
    func fetchSuccess() {
        completeClosure(true, facts, CustomMessages.empty)
    }
    
    //Returns the failed resonse
    func fetchFail(error: String?) {
        completeClosure(false, nil, CustomMessages.defaultResponseError)
    }
}
