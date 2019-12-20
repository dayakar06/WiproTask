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
    func testFetchFactsDetailsAPICallSuccess() {
        mockAPIHelper.facts = self.facts
        factsViewModel.fetchFactsData()
        
        XCTAssert(mockAPIHelper!.isFetchFactsDataAPICalled, "Facts API should have called")
    }
    
    //Used to check the API call failing case
    func testFetchFactsDetailsAPICallFail() {
        let error = CustomMessages.defaultResponseError
        
        factsViewModel.fetchFactsData()
        mockAPIHelper.fetchFail(error: error )
        
        XCTAssertEqual(factsViewModel.alertMessage, error, "Facts API call should fail with error")
    }
    
    //Used to check the loader funtionality
    func testAPICallStatus() {
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        factsViewModel.updateLoadingStatusClosure = { [weak self] in
            loadingStatus = self?.factsViewModel.factsApiCalling ?? false
            expect.fulfill()
        }
        
        factsViewModel.fetchFactsData()
        XCTAssertTrue(loadingStatus, "Facts API shuold be loading")
        
        mockAPIHelper!.fetchSuccess()
        XCTAssertFalse(loadingStatus, "Facts API shuold not be loading")
        wait(for: [expect], timeout: TestExpectionTime.short)
    }
    
    //Used to check the rows count for dummy data
    func testNumberOfRowsCount() {
        mockAPIHelper.facts = self.facts
        let expect = XCTestExpectation(description: "numberOfCellsCunt")
        factsViewModel.reloadTableViewClosure = { () in
            expect.fulfill()
        }
        
        factsViewModel.fetchFactsData()
        mockAPIHelper.fetchSuccess()
        
        XCTAssertEqual(factsViewModel.numberOfCells, facts?.rows?.count, "Fact rows should match")
        wait(for: [expect], timeout: TestExpectionTime.short)
    }
    
    //Used to check the fact title
    func testFactsRowTitle() {
        self.fetchFactsFinished()
        let cellRow = 2
        
        let testFactRow = mockAPIHelper.facts.rows?[cellRow]
        let factRow = factsViewModel.valueAtIndex(cellRow)
        
        XCTAssertEqual(testFactRow?.title, factRow?.title, "Fact title should match")
    }
    
    //Used to check the fact description
    func testFactDescription() {
        self.fetchFactsFinished()
        let cellRow = 2
        
        let testPhoto = mockAPIHelper.facts.rows?[cellRow]
        let factRow = factsViewModel.valueAtIndex(cellRow)
        
        XCTAssertEqual(testPhoto?.description, factRow?.description, "Fact description should match")
    }
}

//Extenstion used to update/Fetch the static data from local facts data
extension FactsViewModelTests{
    var facts : Facts?{
        guard let facts : Facts = try? JSONDecoder().decode(Facts.self, from: FactsReponse.factData) else{
            return nil
        }
        return facts
    }
    
    private func fetchFactsFinished() {
        mockAPIHelper.facts = self.facts
        factsViewModel.fetchFactsData()
        mockAPIHelper.fetchSuccess()
    }
}


//Used to mock test the API calls
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
