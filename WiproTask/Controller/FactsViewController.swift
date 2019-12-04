//
//  ViewController.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 0/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import UIKit

class FactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate let factsCellId = "FactCell"
    fileprivate let noDataAvailable = "NoDataAvaiable"
    
    var tableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .groupTableViewBackground
        tableView.rowHeight = 20
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    var facts = Facts(){
        didSet{
            DispatchQueue.main.async {
                self.title = self.facts.title ?? ""
                self.tableView.reloadData()
            }
        }
    }
    
    var factsApiCalling = false
    var dataRefreshControl: UIRefreshControl?
    
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
        //TODO: Updating with refersh controller
        self.dataRefreshControl = UIRefreshControl()
        self.dataRefreshControl?.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        self.dataRefreshControl?.tintColor = .darkGray
        self.dataRefreshControl?.attributedTitle = NSAttributedString(string: "Fetching Updated Details...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 15)])
        self.tableView.refreshControl = self.dataRefreshControl
        //TODO: get the facts data
        self.getFactsData()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        self.getFactsData()
    }
    
    //TODO: Get facts data
    func getFactsData(){
        self.facts = Facts(title: "", rows: [Rows]())
        DispatchQueue.global(qos: .utility).async {
            self.getData()
        }
    }
    
    //MARK:- Webservices
    func getData(){
        if self.factsApiCalling{
            return
        }
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
            DispatchQueue.main.async {
                self?.dataRefreshControl?.endRefreshing()
            }
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
            else{
                DispatchQueue.main.async {
                    self?.showToast(message: CustomMessages.defaultResponseError)
                }
            }
        }
    }
    
    //MARK:- TableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.facts.rows?.count == 0{
            return 1
        }
        return self.facts.rows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.facts.rows?.count == 0{
            return self.tableView.frame.height
        }
        return UITableView.automaticDimension
    }
    
    //MARK:- TableViwe datasouce methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.facts.rows?.count ?? 0 > 0, indexPath.row < (self.facts.rows?.count ?? 0), let factDetails = self.facts.rows?[indexPath.row], let cell : FactsRowsTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.factsCellId, for: indexPath) as? FactsRowsTableViewCell{
            cell.factDetails = factDetails
            cell.selectionStyle = .none
            cell.detailContainerTopAnchorSpace.constant = indexPath.row == 0 ? 10 : 5
            cell.detailContainerBottomAnchorSpace.constant = indexPath.row == self.facts.rows?.count ? -10 : -5
            return cell
        }
        else if self.facts.rows?.count == 0, let cell : NoDataAvaiableTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.noDataAvailable, for: indexPath) as? NoDataAvaiableTableViewCell{
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}

