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
    //SUT
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
    
    //To check the default NavigationViewController title
    func testViewTitleDoNotHasTitle() {
        XCTAssertTrue(self.viewController.title == nil, "View title should be empty")
    }
    
    //To check the NavigationViewController title update status
    func testViewTitleDoHasTitle() {
        let viewTitle = "Test Title"
        self.viewController.title = viewTitle
        
        XCTAssertTrue(self.viewController.title == viewTitle, "View title should not empty")
    }
    
    //To check the Tableview datasource assign status
    func testTableViewHasDataSource() {
        XCTAssertNotNil(self.viewController.tableView.dataSource)
    }
    
    //To check the tableview numberOfRowsInSection method return count == 1 when facts rows count are not available
    func testNumberOfColumsWithOutData(){
        self.viewController.facts = Facts()
        let seection = 0
        
        self.viewController.tableView.reloadData()
        
        XCTAssertTrue(self.viewController.tableView(self.viewController.tableView, numberOfRowsInSection: seection) == 1, file: "Should be 1 because we showing the NoDataAvaiableTableViewCell")
    }
    
    //To check the tableview numberOfRowsInSection method return count when facts rows count are available
    func testNumberOfRowsWithSectionWithData() {
        let seection = 0
        var rows = [Rows]()
        rows.append(Rows.init(title: "Beavers", description: "Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony", imagePath: "http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"))
        rows.append(Rows.init(title: "Hockey Night in Canada", description: "These Saturday night CBC broadcasts originally aired on radio in 1931. In 1952 they debuted on television and continue to unite (and divide) the nation each week", imagePath: "http://fyimusic.ca/wp-content/uploads/2008/06/hockey-night-in-canada.thumbnail.jpg"))
        rows.append(Rows.init(title: "Housing", description: "Warmer than you might think.", imagePath: "http://icons.iconarchive.com/icons/iconshock/alaska/256/Igloo-icon.png"))
        
        self.viewController.facts = Facts(title: "Test Title", rows: rows)
        
        XCTAssertTrue(self.viewController.tableView(self.viewController.tableView, numberOfRowsInSection: seection) == 3, file: "Tableview should have 3 rows")
    }
    
    //To check the NoDataAvaiableTableViewCell return from cellForRowAt when facts row records are not available
    func testNoDataAvaiableTableViewCellIncaseDataNotThere() {
        let row = 0
        let section = 0
        
        let rows = [Rows]()
        self.viewController.facts = Facts(title: "Test Title", rows: rows)
        
        let indexPath = IndexPath(row: row, section: section)
        
        XCTAssertTrue(self.viewController.tableView(self.viewController.tableView, cellForRowAt: indexPath) is NoDataAvaiableTableViewCell, "Tableview cell should  be return FactsRowsTableViewCell type")
    }
    
    //To check the FactsRowsTableViewCell return from cellForRowAt when facts row records are available
    func testTableViewCellTypeShouldFactsRowsTableViewCell() {
        let row = 0
        let section = 0
        
        var rows = [Rows]()
        rows.append(Rows.init(title: "Beavers", description: "Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony", imagePath: "http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"))
        self.viewController.facts = Facts(title: "Test Title", rows: rows)
        
        let indexPath = IndexPath(row: row, section: section)
        
        XCTAssertTrue(self.viewController.tableView(self.viewController.tableView, cellForRowAt: indexPath) is FactsRowsTableViewCell, "Tableview cell should be return FactsRowsTableViewCell type")
    }
    
    //To check the tableview FactRowTableViewCell title when title is not available for the fact row
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
    
    //To check the tableview FactRowTableViewCell description when description is not available for the fact row
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
    
    //To check the tableview FactRowTableViewCell imagelink when imagelink is not available for the fact row
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
