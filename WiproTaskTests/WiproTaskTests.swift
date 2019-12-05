//
//  WiproTaskTests.swift
//  WiproTaskTests
//
//  Created by Dayakar Reddy on 04/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import XCTest
@testable import WiproTask

class WiproTaskTests: XCTestCase {
    
    var viewController : FactsViewController!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.viewController = FactsViewController()
        self.viewController.loadView()
        self.viewController.viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.viewController = nil
        super.tearDown()
    }
    
    func testHasController(){
        XCTAssertNotNil(self.viewController)
    }
    
    func testHasATableView() {
        XCTAssertNotNil(self.viewController.tableView)
    }
    
    func testTableViewHasDelegate() {
        XCTAssertNotNil(self.viewController.tableView.delegate)
    }
    
    func testViewTitleDoNotHasTitle() {
        XCTAssertTrue(self.viewController.title == nil, "View title should be empty")
    }
    
    func testViewTitleDoHasTitle() {
        let viewTitle = "Test Title"
        self.viewController.title = viewTitle
        
        XCTAssertTrue(self.viewController.title == viewTitle, "View title should not empty")
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(self.viewController.tableView.dataSource)
    }
    
    func testNumberOfColumsWithOutData(){
        self.viewController.facts = Facts()
        let seection = 0
        
        self.viewController.tableView.reloadData()
        
        XCTAssertTrue(self.viewController.tableView(self.viewController.tableView, numberOfRowsInSection: seection) == 1, file: "Should be 1 because we showing the NoDataAvaiableTableViewCell")
    }
    
    func testNumberOfRowsWithSectionWithData() {
        let seection = 0
        var rows = [Rows]()
        rows.append(Rows.init(title: "Beavers", description: "Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony", imagePath: "http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"))
        rows.append(Rows.init(title: "Hockey Night in Canada", description: "These Saturday night CBC broadcasts originally aired on radio in 1931. In 1952 they debuted on television and continue to unite (and divide) the nation each week", imagePath: "http://fyimusic.ca/wp-content/uploads/2008/06/hockey-night-in-canada.thumbnail.jpg"))
        rows.append(Rows.init(title: "Housing", description: "Warmer than you might think.", imagePath: "http://icons.iconarchive.com/icons/iconshock/alaska/256/Igloo-icon.png"))
        
        self.viewController.facts = Facts(title: "Test Title", rows: rows)
        
        XCTAssertTrue(self.viewController.tableView(self.viewController.tableView, numberOfRowsInSection: seection) == 3, file: "Tableview should have 3 rows")
    }
    
    func testNoDataAvaiableTableViewCellIncaseDataNotThere() {
        let row = 0
        let section = 0
        
        let rows = [Rows]()
        self.viewController.facts = Facts(title: "Test Title", rows: rows)
        
        let indexPath = IndexPath(row: row, section: section)
        
        XCTAssertTrue(self.viewController.tableView(self.viewController.tableView, cellForRowAt: indexPath) is NoDataAvaiableTableViewCell, "Tableview cell should not be FactsRowsTableViewCell type")
    }
    
    func testTableViewCellTypeShouldFactsRowsTableViewCell() {
        let row = 0
        let section = 0
        
        var rows = [Rows]()
        rows.append(Rows.init(title: "Beavers", description: "Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony", imagePath: "http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"))
        self.viewController.facts = Facts(title: "Test Title", rows: rows)
        
        let indexPath = IndexPath(row: row, section: section)
        
        XCTAssertTrue(self.viewController.tableView(self.viewController.tableView, cellForRowAt: indexPath) is FactsRowsTableViewCell, "Tableview cell should be FactsRowsTableViewCell type")
    }
    
    func testTableViewCellDetailsTitle() {
        var rows = [Rows]()
        rows.append(Rows.init(title: "Beavers", description: "Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony", imagePath: "http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"))
        rows.append(Rows.init(title: nil, description: "These Saturday night CBC broadcasts originally aired on radio in 1931. In 1952 they debuted on television and continue to unite (and divide) the nation each week", imagePath: "http://fyimusic.ca/wp-content/uploads/2008/06/hockey-night-in-canada.thumbnail.jpg"))
        rows.append(Rows.init(title: "Housing", description: nil, imagePath: "http://icons.iconarchive.com/icons/iconshock/alaska/256/Igloo-icon.png"))
        
        self.viewController.facts = Facts(title: "Test Title", rows: rows)
        
        let section = 0
        let row = 1
        let indexPath = IndexPath(row: row, section: section)
        
        let cell : FactsRowsTableViewCell = self.viewController.tableView(self.viewController.tableView, cellForRowAt: indexPath) as! FactsRowsTableViewCell
        
        XCTAssertTrue(cell.titleLabel.text == rows[row].title ?? "--", "Tableview cell should be FactsRowsTableViewCell type")
    }
    
    func testTableViewCellDetailsDescription() {
        var rows = [Rows]()
        rows.append(Rows.init(title: "Housing", description: nil, imagePath: "http://icons.iconarchive.com/icons/iconshock/alaska/256/Igloo-icon.png"))
        
        self.viewController.facts = Facts(title: "Test Title", rows: rows)
        
        let section = 0
        let row = 0
        let indexPath = IndexPath(row: row, section: section)
        
        let cell : FactsRowsTableViewCell = self.viewController.tableView(self.viewController.tableView, cellForRowAt: indexPath) as! FactsRowsTableViewCell
        
        XCTAssertTrue(cell.descriptionLabel.text == rows[row].description ?? "--", "Tableview cell should be FactsRowsTableViewCell type")
    }
    
    func testTableViewCellDetailsImagePath() {
        var rows = [Rows]()
        rows.append(Rows.init(title: "Housing", description: "Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony", imagePath: nil))
        
        self.viewController.facts = Facts(title: "Test Title", rows: rows)
        
        let section = 0
        let row = 0
        let indexPath = IndexPath(row: row, section: section)
        
        let cell : FactsRowsTableViewCell = self.viewController.tableView(self.viewController.tableView, cellForRowAt: indexPath) as! FactsRowsTableViewCell
        
        XCTAssertTrue(cell.factDetails.imageHref == rows[row].imageHref , "Tableview cell image path should be nil")
    }
}
