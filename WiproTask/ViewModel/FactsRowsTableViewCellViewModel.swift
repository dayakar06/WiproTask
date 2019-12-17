//
//  FactsRowsTableViewCellViewModel.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 17/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import Foundation
class FactsRowsTableViewCellViewModel{
    //Row Data Model
    private var factRow: Rows?
    
    //Facts details ex: title, description and fact image link
    var title: String = ""
    var description: String = ""
    var factImageLink: String = ""
    
    //Initializes the FactsRowsTableViewCellViewModel
    init(factRow: Rows) {
        self.factRow = factRow
        configureOutput()
    }
    
    //Used to configure the FactsTableViewCell
    private func configureOutput() {
        self.factImageLink = self.factRow?.imageHref ?? ""
        self.title = self.factRow?.title ?? ""
        self.description = self.factRow?.description ?? ""
    }
    
    //Used to return the data avaiable status
    var noDataAvaiable : Bool{
        return (self.title.isEmpty && self.description.isEmpty && self.factImageLink.isEmpty)
    }
    
    //Used to return the Image avaiable status
    var imageURL: URL?{
        guard let imageUrl : String = self.factRow?.imageHref, !imageUrl.isEmpty else {
            return nil
        }
        return URL.init(string: imageUrl) ?? nil
    }
}
