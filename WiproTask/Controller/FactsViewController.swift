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
    var facts = Facts(){
        didSet{
            //Updating the view title and reloading the tableview
            DispatchQueue.main.async {
                self.title = self.facts.title ?? ""
                self.tableView.reloadData()
            }
        }
    }
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
        //TODO: Tableview customization
        self.view.addSubview(self.tableView)
        self.view.backgroundColor = .groupTableViewBackground
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(FactsRowsTableViewCell.self, forCellReuseIdentifier: self.factsCellId)
        self.tableView.register(NoDataAvaiableTableViewCell.self, forCellReuseIdentifier: self.noDataAvailable)
        self.addRefreshControllerToTableView()
        //TODO: get the facts data
        self.getFactsData()
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
        self.getFactsData()
    }
    
    //TODO: To refresh the facts data
    func getFactsData(){
        self.facts = Facts(title: "", rows: [Rows]())
        DispatchQueue.global(qos: .utility).async {
            self.getData()
        }
    }
    
    //MARK:- Webserices
    //API call used to get the facts details from server
    func getData(){
        //Stoping from API call, incase API calling currently.
        if self.factsApiCalling{
            return
        }
        //Checking the internet connectivity
        if !reachability.isReachable{
            DispatchQueue.main.async {
                self.presentAlert(withTitle: CustomMessages.noInternet, message: nil, complitionHandler: {[weak self] in
                    self?.dataRefreshControl?.endRefreshing()
                })
            }
            return
        }
        self.factsApiCalling = true
        APIHelper.shared.codableGetRequestWith(apiName: APIs.facts, headers: ["Content-Type": "application/json"]) { [weak self] (status, data, message) in
            self?.factsApiCalling = false
            //Ending the refresh controller
            DispatchQueue.main.async {
                self?.dataRefreshControl?.endRefreshing()
            }
            //On susccessful api call reponse paring the data.
            if status{
                if let facts : Facts = try? JSONDecoder().decode(Facts.self, from: data!){
                    #if DEBUG
                        print("Facts Count = \(facts.rows?.count ?? 0)")
                    #endif
                    self?.facts = facts
                }
                else{
                    DispatchQueue.main.async {
                        self?.showToast(message: CustomMessages.dataParseError)
                    }
                }
            }
            //On API call failure showing the error message
            else{
                DispatchQueue.main.async {
                    self?.showToast(message: message)
                }
            }
        }
    }
    
    //MARK:- TableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Incase of facts not available returning the 1 to show the no data available cell.
        if self.facts.rows?.count == 0{
            return 1
        }
        return self.facts.rows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Incase of facts data not available setting height equals to the tableview
        if self.facts.rows?.count == 0{
            return self.tableView.frame.height
        }
        return UITableView.automaticDimension
    }
    
    //MARK:- TableViwe datasouce methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Incase facts data available showing the facts data.
        if self.facts.rows?.count ?? 0 > 0, indexPath.row < (self.facts.rows?.count ?? 0), let factDetails = self.facts.rows?[indexPath.row], let cell : FactsRowsTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.factsCellId, for: indexPath) as? FactsRowsTableViewCell{
            cell.factDetails = factDetails
            cell.selectionStyle = .none
            cell.detailContainerTopAnchorSpace.constant = indexPath.row == 0 ? 10 : 5
            cell.detailContainerBottomAnchorSpace.constant = indexPath.row == self.facts.rows?.count ? -10 : -5
            return cell
        }
        //Incase of facts not receied or internet connection issue, showing the no data available cell.
        else if self.facts.rows?.count == 0, let cell : NoDataAvaiableTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.noDataAvailable, for: indexPath) as? NoDataAvaiableTableViewCell{
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}

