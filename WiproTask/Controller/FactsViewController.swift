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
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
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
        DispatchQueue.global(qos: .utility).async {
            self.getData()
        }
    }
    
    //MARK:- Webservices
    func getData(){
        if self.factsApiCalling{
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
        return self.facts.rows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK:- TableViwe datasouce methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell : FactsRowsTableViewCell = tableView.dequeueReusableCell(withIdentifier: factsCellId, for: indexPath) as? FactsRowsTableViewCell,
            indexPath.row < (self.facts.rows?.count ?? 0),
            let factDetails = self.facts.rows?[indexPath.row]{
            cell.factDetails = factDetails
            cell.selectionStyle = .none
            cell.detailContainerTopAnchorSpace.constant = indexPath.row == 0 ? 10 : 5
            cell.detailContainerBottomAnchorSpace.constant = indexPath.row == self.facts.rows?.count ? -10 : -5
            return cell
        }
        return UITableViewCell()
    }
}

