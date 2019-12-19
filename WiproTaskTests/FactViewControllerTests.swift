//
//  FactViewControllerTests.swift
//  WiproTaskTests
//
//  Created by Dayakar Reddy on 18/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import XCTest

@testable import WiproTask

class FactViewControllerTests: XCTestCase {
    //SUT
    var viewController : FactsViewController!
    var factsViewModel : FactsViewModel!
    var mockAPIHelper : MockAPIHelper!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.mockAPIHelper = MockAPIHelper()
        self.factsViewModel = FactsViewModel(apiHelper: mockAPIHelper)
        self.viewController = FactsViewController()
        self.viewController.factsViewModel = self.factsViewModel
        self.viewController.viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.viewController = nil
        self.factsViewModel = nil
        self.mockAPIHelper = nil
        
        super.tearDown()
    }
    
    //To check the view controller creation
    func testHasController(){
        XCTAssertNotNil(self.viewController)
    }
    
    //To check the tableview creation
    func testHasATableView() {
        XCTAssertNotNil(self.viewController.tableView)
    }
    
    //TO check the tableview delegate assign status
    func testTableViewHasDelegate() {
        XCTAssertNotNil(self.viewController.tableView.delegate)
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(self.viewController.tableView.dataSource)
    }
    
    //To check the default NavigationViewController title
    func testViewTitleNotAvailable() {
        XCTAssertTrue(self.viewController.title == nil, "View title should be empty")
    }
    
    //To check the facts view controller title
    func testFactsViewControllerTitle() {
        let facts = emptyFactsData()
        mockAPIHelper.facts = facts
        let expect = XCTestExpectation(description: "FactsViewController title")
        viewController.factsViewModel.reloadTableViewClosure = { () in
            self.viewController.title = self.factsViewModel.factsTitle
            expect.fulfill()
        }
        factsViewModel.fetchFactsData()
        mockAPIHelper.fetchSuccess()
        wait(for: [expect], timeout: 2.0)
        XCTAssertEqual(self.viewController.title, mockAPIHelper.facts.title)
    }
    
    //To check the tableview  rows count when facts data not available, here it should return 1 row to show the NoDataAvaiableTableViewCell
    func testNumberOfRowsForTableViewWithOutData() {
        let section = 0
        
        self.fetchEmptyFactsFactsData()
        
        XCTAssertEqual(self.viewController.tableView(self.viewController.tableView, numberOfRowsInSection: section), 1, "Tableview cells count should be 1(To show the status TableViewCell)")
    }
    
    //To check the tableview  rows count when facts data available
    func testNumberOfRowsForTableVie1wWithData() {
        let section = 0
        
        self.fetchFactsFactsData()
        
        XCTAssertEqual(self.viewController.tableView(self.viewController.tableView, numberOfRowsInSection: section), mockAPIHelper.facts.rows?.count)
    }
    
    //To check the returning tableview cell when facts data not available
    func testTableViewCellTypeWithOutData() {
        let section = 0
        let row = 0
        let indexPath = IndexPath(row: row, section: section)
        
        self.fetchEmptyFactsFactsData()
        
        XCTAssertTrue(self.viewController.tableView(self.viewController.tableView, cellForRowAt: indexPath) is NoDataAvaiableTableViewCell, "Tableview cell should be return NoDataAvaiableTableViewCell to show the status")
    }
    
    //To check the returning tableview cell when facts data available
    func testTableViewCellTypeWithData() {
        let section = 0
        let row = 0
        let indexPath = IndexPath(row: row, section: section)
        
        self.fetchFactsFactsData()
        
        XCTAssertTrue(self.viewController.tableView(self.viewController.tableView, cellForRowAt: indexPath) is FactsRowsTableViewCell, "Tableview cell should be return FactsRowsTableViewCell to show the fcats details")
    }
    
    //to check the facts rows tableview details configuration when facts data avaialbe
    func testTableViewCellDetails() {
        let section = 0
        let row = 0
        let indexPath = IndexPath(row: row, section: section)
        
        self.fetchFactsFactsData()
        
        guard let factsRowsTableViewCell : FactsRowsTableViewCell = self.viewController.tableView(self.viewController.tableView, cellForRowAt: indexPath) as? FactsRowsTableViewCell else {
            XCTAssert(false, "Unable to create FactsRowsTableViewCell")
            return
        }
        let testFactRow = mockAPIHelper.facts.rows?[row]
        XCTAssertEqual(factsRowsTableViewCell.titleLabel.text, testFactRow?.title,"Title should match")
        XCTAssertEqual(factsRowsTableViewCell.descriptionLabel.text, testFactRow?.description,"Title should match")
    }
}

//Extenstion used to Fetch the static facts data
extension FactViewControllerTests{
    func factsData() -> Facts{
        guard let factsData = FactsReponse.factStringData.data(using: .utf8), let facts : Facts = try? JSONDecoder().decode(Facts.self, from: factsData) else{
            return Facts()
        }
        return facts
    }
    
    func emptyFactsData() -> Facts{
        return Facts()
    }
    
    private func fetchFactsFactsData() {
        mockAPIHelper.facts = factsData()
        factsViewModel.fetchFactsData()
        mockAPIHelper.fetchSuccess()
    }
    
    private func fetchEmptyFactsFactsData() {
        mockAPIHelper.facts = emptyFactsData()
        factsViewModel.fetchFactsData()
        mockAPIHelper.fetchSuccess()
    }
}
