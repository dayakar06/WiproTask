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
        super.tearDown()
    }
    
    //Used to check data not avaliable behaviour
    func testFactViewModelDataNotAvailableState() {
        let fact = Rows(title: nil, description: nil, imagePath: nil)
        self.factsViewTableViewCellVM = FactsRowsTableViewCellViewModel(factRow: fact)
        
        XCTAssertFalse(self.factsViewTableViewCellVM.isFactDataAvaiable)
    }
    
    //Used to check image path/URL behaviour when image url not available
    func testFactIamgePathWithEmptyImage(){
        let fact = Rows(title: "", description: "", imagePath: "")
        self.factsViewTableViewCellVM = FactsRowsTableViewCellViewModel(factRow: fact)
        
        XCTAssertNil(self.factsViewTableViewCellVM.imageURL, "Image url sould be nil")
    }
    
    //Used to check image path/URL behaviour when image url available
    func testFactIamgePath(){
        let fact = Rows(title: "", description: "", imagePath: "http://1.bp.blogspot.com/_VZVOmYVm68Q/SMkzZzkGXKI/AAAAAAAAADQ/U89miaCkcyo/s400/the_golden_compass_still.jpg")
        self.factsViewTableViewCellVM = FactsRowsTableViewCellViewModel(factRow: fact)
        
        XCTAssertNotNil(self.factsViewTableViewCellVM.imageURL, "Image url sould not be nil")
    }
    
    //Used to validate all data availability(title, description, image link)
    func testFactViewModelDataAvailable() {
        let fact = Rows(title: "Beavers", description: "Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony", imagePath: "http://1.bp.blogspot.com/_VZVOmYVm68Q/SMkzZzkGXKI/AAAAAAAAADQ/U89miaCkcyo/s400/the_golden_compass_still.jpg")
        self.factsViewTableViewCellVM = FactsRowsTableViewCellViewModel(factRow: fact)
        
        
        XCTAssertTrue(self.factsViewTableViewCellVM.title == fact.title)
        XCTAssertTrue(self.factsViewTableViewCellVM.description == fact.description)
        XCTAssertTrue(self.factsViewTableViewCellVM.factImageLink == fact.imageHref)
        XCTAssertNotNil(self.factsViewTableViewCellVM.imageURL)
    }
}
