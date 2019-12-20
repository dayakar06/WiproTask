//
//  FactsRowsTableViewCellViewModelTests.swift
//  WiproTaskTests
//
//  Created by Dayakar Reddy on 18/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import XCTest

@testable import WiproTask

class FactsRowsTableViewCellViewModelTests: XCTestCase {
    
    //SUT
    var factsViewTableViewCellVM : FactsRowsTableViewCellViewModel!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.factsViewTableViewCellVM = nil
        
        super.tearDown()
    }
    
    //Used to check data not avaliable behaviour
    func testFactViewModelDataNotAvailableState() {
        let fact = try? JSONDecoder().decode(Rows.self, from: FactsReponse.emptyRowData)
        self.factsViewTableViewCellVM = FactsRowsTableViewCellViewModel(factRow: fact ?? nil)
        
        XCTAssertFalse(self.factsViewTableViewCellVM.isFactDataAvaiable, "Fact descrition sould not be available")
    }
    
    //Used to check image path/URL behaviour when image url not available
    func testFactImagePathWithEmptyImage(){
        let fact = try? JSONDecoder().decode(Rows.self, from: FactsReponse.emptyRowData)
        self.factsViewTableViewCellVM = FactsRowsTableViewCellViewModel(factRow: fact ?? nil)
        
        XCTAssertNil(self.factsViewTableViewCellVM.imageURL, "Image url sould be nil")
    }
    
    //Used to check image path/URL behaviour when image url available
    func testFactImagePath(){
        let fact = try? JSONDecoder().decode(Rows.self, from: FactsReponse.rowData)
        self.factsViewTableViewCellVM = FactsRowsTableViewCellViewModel(factRow: fact ?? nil)
        
        XCTAssertNotNil(self.factsViewTableViewCellVM.imageURL, "Image url sould not be nil")
    }
    
    //Used to validate all data availability(title, description, image link)
    func testFactViewModelDetailsAvailable() {
        let fact = try? JSONDecoder().decode(Rows.self, from: FactsReponse.rowData)
        self.factsViewTableViewCellVM = FactsRowsTableViewCellViewModel(factRow: fact ?? nil)
        
        XCTAssertTrue(self.factsViewTableViewCellVM.title == fact?.title, "Fact title sould not be nil")
        XCTAssertTrue(self.factsViewTableViewCellVM.description == fact?.description, "Fact descrition sould not be nil")
        XCTAssertTrue(self.factsViewTableViewCellVM.factImageLink == fact?.imageHref, "Fact image link sould not be nil")
        XCTAssertNotNil(self.factsViewTableViewCellVM.imageURL, "Fact image url sould not be nil")
    }
}
