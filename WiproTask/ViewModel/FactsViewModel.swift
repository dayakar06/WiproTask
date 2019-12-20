//
//  FactsViewModel.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 17/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import Foundation

class FactsViewModel{
    
    //API calls
    let apiHelper: APIHelperProtocol
    
    //Closures used to communicate with View(FactViewController)
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: ((String)->())?
    var updateLoadingStatusClosure: (()->())?
    
    //Stores and updates the facts data/details to the FactViewController
    private var facts: Facts?{
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    //Store and update the loading/API call status to the FactViewController
    var factsApiCalling: Bool = false {
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
        return facts?.title ?? ""
    }
    
    //Returns the number of facts
    var numberOfCells: Int {
        guard let factsCount = self.facts?.rows?.count else{
            return 0
        }
        return factsCount
    }
    
    //Reachablitily to check the internet connection
    let reachability = Reachability()!
    
    init(apiHelper: APIHelperProtocol = APIHelper()) {
        self.apiHelper = apiHelper
    }
    
    //TO fetch the data from server
    func fetchFactsData() {
        //Prevents the API calls, in case of currently API is calling.
        if self.factsApiCalling{
            return
        }
        self.factsApiCalling = true
        self.removeAllFacts()
        //Checking the internet connectivity
        self.apiHelper.codableGetRequestWith(apiName: APIs.facts, headers: HTTPHeaders.contentTypeJson) { [weak self] (status, facts, message) in
            self?.factsApiCalling = false
            //On susccessful api call reponse paring the data.
            if status{
                self?.facts = facts ?? nil
            }
            //On API call failure showing the error message
            else{
                self?.alertMessage = message
            }
        }
    }
    
    //Resets the facts data
    func removeAllFacts(){
        self.facts = nil
        self.reloadTableViewClosure?()
    }
    
    //Provides the facts details at given inxex
    func valueAtIndex(_ index:Int) -> Rows?{
        return self.facts?.rows?[index] ?? nil
    }
}
