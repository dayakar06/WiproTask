//
//  NoDataAvaiableTableViewCell.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 05/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import UIKit

class NoDataAvaiableTableViewCell: UITableViewCell {

    let statusLabel = UILabel()
    let detailContainerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        self.detailContainerView.backgroundColor = .white
        self.detailContainerView.layer.cornerRadius = 5
        
        self.statusLabel.numberOfLines = 0
        self.statusLabel.textAlignment = .center
        self.statusLabel.lineBreakMode = .byWordWrapping
        self.statusLabel.text = CustomMessages.noData
        self.statusLabel.textColor = .darkText
        self.statusLabel.font = UIFont.boldSystemFont(ofSize: 26.0)
        
        self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.detailContainerView.addSubview(self.statusLabel)
        addSubview(self.detailContainerView)
        
        // lets set up some constraints for our label
        let constraints = [
            //status label constraints
            self.statusLabel.leadingAnchor.constraint(equalTo: self.detailContainerView.leadingAnchor, constant: 10.0),
            self.detailContainerView.trailingAnchor.constraint(equalTo: self.statusLabel.trailingAnchor, constant: 10.0),
            self.statusLabel.topAnchor.constraint(equalTo: self.detailContainerView.topAnchor, constant: 10.0),
            self.detailContainerView.bottomAnchor.constraint(equalTo: self.statusLabel.bottomAnchor, constant: 10.0),
            //Details constainer view constraints
            self.detailContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            self.trailingAnchor.constraint(equalTo: self.detailContainerView.trailingAnchor, constant: 10.0),
            self.detailContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
            self.bottomAnchor.constraint(equalTo: self.detailContainerView.bottomAnchor, constant: 10.0)
        ]
        NSLayoutConstraint.activate(constraints)
        #if DEBUG
        print("\n\n\nLayput is activated\n\n\n")
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

