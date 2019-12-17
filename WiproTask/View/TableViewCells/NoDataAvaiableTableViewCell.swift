//
//  NoDataAvaiableTableViewCell.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 05/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import UIKit

class NoDataAvaiableTableViewCell: UITableViewCell {
    
    //All the views
    let statusLabel = UILabel()
    let detailContainerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        //Customizing the details container view
        self.detailContainerView.backgroundColor = .white
        self.detailContainerView.layer.cornerRadius = CornerRadios._5
        //Customizing the status lebel
        self.statusLabel.numberOfLines = LabelTextLines.l0
        self.statusLabel.textAlignment = .center
        self.statusLabel.lineBreakMode = .byWordWrapping
        self.statusLabel.text = CustomMessages.noData
        self.statusLabel.textColor = .darkText
        self.statusLabel.font = UIFont.boldSystemFont(ofSize: FontSize.s26)
        //Disabling the translates autoresiging maks into constraints functionality.
        self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailContainerView.translatesAutoresizingMaskIntoConstraints = false
        //Adding view to tableviewcell
        self.detailContainerView.addSubview(self.statusLabel)
        addSubview(self.detailContainerView)
        //Adding constriants/Constarint setup and activating them.
        let constraints = [
            //status label constraints
            self.statusLabel.leadingAnchor.constraint(equalTo: self.detailContainerView.leadingAnchor, constant: ViewsSpacing.outer),
            self.detailContainerView.trailingAnchor.constraint(equalTo: self.statusLabel.trailingAnchor, constant: ViewsSpacing.outer),
            self.statusLabel.topAnchor.constraint(equalTo: self.detailContainerView.topAnchor, constant: ViewsSpacing.outer),
            self.detailContainerView.bottomAnchor.constraint(equalTo: self.statusLabel.bottomAnchor, constant: ViewsSpacing.outer),
            //Details constainer view constraints
            self.detailContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ViewsSpacing.outer),
            self.trailingAnchor.constraint(equalTo: self.detailContainerView.trailingAnchor, constant: ViewsSpacing.outer),
            self.detailContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: ViewsSpacing.outer),
            self.bottomAnchor.constraint(equalTo: self.detailContainerView.bottomAnchor, constant: ViewsSpacing.outer)
        ]
        NSLayoutConstraint.activate(constraints)
        #if DEBUG
        print("\n\n\nLayout is activated\n\n\n")
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

