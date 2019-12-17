//
//  ViewController.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 0/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import UIKit

class FactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Tableview
    var tableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .groupTableViewBackground
        tableView.rowHeight = 20
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    //Tablevuew cell ReusableCellIdentifiers
    fileprivate let factsCellId = "FactCell"
    fileprivate let noDataAvailable = "NoDataAvaiable"
    
    //Facts variable to store the facts API response
    lazy var factsViewModel: FactsViewModel = {
        return FactsViewModel()
    }()
    //To prevent API calls continuously...
    var factsApiCalling = false
    //Refreshcontroler to add
    var dataRefreshControl: UIRefreshControl?
    //Reachablitily to check the internet connection
    let reachability = Reachability()!
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView)
        self.view.backgroundColor = .groupTableViewBackground
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(FactsRowsTableViewCell.self, forCellReuseIdentifier: self.factsCellId)
        self.tableView.register(NoDataAvaiableTableViewCell.self, forCellReuseIdentifier: self.noDataAvailable)
        self.addRefreshControllerToTableView()
        
        self.initiateFactsViewModel()
    }
    
    //To add refresh control to tableview
    func addRefreshControllerToTableView(){
        self.dataRefreshControl = UIRefreshControl()
        self.dataRefreshControl?.addTarget(self, action: #selector(self.refreshFactsRowsData(_:)), for: .valueChanged)
        self.dataRefreshControl?.tintColor = .darkGray
        self.dataRefreshControl?.attributedTitle = NSAttributedString(string: "Fetching Updated Details...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 15)])
        self.tableView.refreshControl = self.dataRefreshControl
    }
    
    //Refresh control observer
    @objc private func refreshFactsRowsData(_ sender: Any) {
        self.factsViewModel.fetchFactsData()
    }
    
    //To refresh the facts data
    func getFactsData(){
        self.factsViewModel.fetchFactsData()
    }
    
    //initializing the FactviewModel binding with view
    func initiateFactsViewModel() {
        self.factsViewModel.removeAllFacts()
        //Error handling
        self.factsViewModel.showAlertClosure = { [weak self] (message) in
            self?.showToast(message: CustomMessages.dataParseError)
        }
        //Updating the API calls status
        self.factsViewModel.updateLoadingStatusClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let isLoading : Bool = self?.factsViewModel.isLoading as Bool?, isLoading {
                    self?.showIndicator()
                }else {
                    self?.hideIndicator()
                    self?.dataRefreshControl?.endRefreshing()
                }
            }
        }
        //TO update the tableview on data receiveing from API or data removed status
        self.factsViewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.title = self?.factsViewModel.factsTitle
                self?.tableView.reloadData()
            }
        }
        self.factsViewModel.fetchFactsData()
    }
    
    
    //MARK:- TableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.factsViewModel.numberOfCells > 0 ? self.factsViewModel.numberOfCells : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Incase of facts data not available setting height equals to the tableview
        if self.factsViewModel.numberOfCells == 0{
            return self.tableView.frame.height
        }
        return UITableView.automaticDimension
    }
    
    //MARK:- TableViwe datasouce methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Incase facts data available showing the facts data.
        if self.factsViewModel.numberOfCells > 0, indexPath.row < (self.factsViewModel.numberOfCells), let factDetails : Rows = self.factsViewModel.valueAtIndex(indexPath.row), let cell : FactsRowsTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.factsCellId, for: indexPath) as? FactsRowsTableViewCell{
            cell.prepareTableViewCellWith(factData: factDetails)
            cell.detailContainerTopAnchorSpace.constant = indexPath.row == 0 ? 10 : 5
            cell.detailContainerBottomAnchorSpace.constant = indexPath.row == self.factsViewModel.numberOfCells ? -10 : -5
            return cell
        }
            //Incase of facts not receied or internet connection issue, showing the no data available cell.
        else if self.factsViewModel.numberOfCells == 0, let cell : NoDataAvaiableTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.noDataAvailable, for: indexPath) as? NoDataAvaiableTableViewCell{
            return cell
        }
        return UITableViewCell()
    }
}
