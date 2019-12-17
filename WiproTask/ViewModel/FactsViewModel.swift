//
//  FactsViewModel.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 17/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import Foundation

class FactsViewModel{
    
    //Closures used to communicate with View(FactViewController)
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: ((String)->())?
    var updateLoadingStatusClosure: (()->())?
    
    //Stores and updates the facts data/details to the FactViewController
    private var facts: Facts = Facts(){
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    //Store and update the loading/API call status to the FactViewController
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatusClosure?()
        }
    }
    
    //Store and updates the alert messages to the factsviewcontroller
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?(alertMessage ?? "")
        }
    }
    
    //Return the FactsViewControler view title
    var factsTitle: String? {
        return facts.title ?? ""
    }
    
    //Returns the number of facts
    var numberOfCells: Int {
        guard let factsCount = self.facts.rows?.count else{
            return 0
        }
        return factsCount
    }
    
    //TO fetch the data from server
    func fetchFactsData() {
        self.isLoading = true
        APIHelper.shared.codableGetRequestWith(apiName: APIs.facts, headers: ["Content-Type": "application/json"]) { [weak self] (status, data, message) in
            self?.isLoading = false
            //On susccessful api call reponse paring the data.
            if status{
                if let facts : Facts = try? JSONDecoder().decode(Facts.self, from: data!){
                    #if DEBUG
                        print("Facts Count = \(facts.rows?.count ?? 0)")
                    #endif
                    self?.facts = facts
                }
                else{
                    self?.alertMessage = CustomMessages.dataParseError
                }
            }
            //On API call failure showing the error message
            else{
                self?.alertMessage = message
            }
        }
    }
    
    //Resets the facts data
    func removeAllFacts(){
        self.facts = Facts()
        self.reloadTableViewClosure?()
    }
    
    //Provides the facts details at given inxex
    func valueAtIndex(_ index:Int) -> Rows?{
        return self.facts.rows?[index] ?? nil
    }
}
