//
//  FactsRowsTableViewCell.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 04/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import UIKit
import SDWebImage

class FactsRowsTableViewCell: UITableViewCell {
    
    //All the views
    let factImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let detailContainerView = UIView()
    
    //Layout contraints to control the detailContainerView and factImageView height
    var detailContainerTopAnchorSpace = NSLayoutConstraint()
    var detailContainerBottomAnchorSpace = NSLayoutConstraint()
    var imageViewHeight = NSLayoutConstraint()
    var imageViewBottomSpace = NSLayoutConstraint()
    
    //Facts data with property observers to update the fact daetail on FactsRowsTableViewCell
    private var factsRowsTableViewCellVM: FactsRowsTableViewCellViewModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        //Customizing the view
        self.detailContainerView.backgroundColor = .white
        self.detailContainerView.layer.cornerRadius = CornerRadius._default
        //Customizing the imageview
        self.factImageView.layer.cornerRadius = CornerRadius._default
        self.factImageView.clipsToBounds = true
        //Customizing the title label
        self.titleLabel.numberOfLines = LabelTextLines.zero
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: FontSize.s17)
        //Customizing the description label
        self.descriptionLabel.numberOfLines = LabelTextLines.zero
        self.descriptionLabel.lineBreakMode = .byWordWrapping
        //Disabling the translates autoresiging maks into constraints functionality
        self.factImageView.translatesAutoresizingMaskIntoConstraints = false
        self.detailContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        //Adding view to tableviewcell
        self.detailContainerView.addSubview(factImageView)
        self.detailContainerView.addSubview(titleLabel)
        self.detailContainerView.addSubview(descriptionLabel)
        addSubview(self.detailContainerView)
        //Adding constriants/Constarint setup and activating them
        self.titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        let constraints = [
            //Fact imageview constraints
            self.factImageView.topAnchor.constraint(equalTo: detailContainerView.topAnchor, constant: ViewsSpacing.inner),
            self.factImageView.leadingAnchor.constraint(equalTo: detailContainerView.leadingAnchor, constant: ViewsSpacing.inner),
            self.factImageView.trailingAnchor.constraint(equalTo: detailContainerView.trailingAnchor, constant: -ViewsSpacing.inner),
            
            self.factImageView.widthAnchor.constraint(equalTo: detailContainerView.widthAnchor, multiplier: ViewSizeRatios._default, constant: -2*ViewsSpacing.inner),
            //Title label constraints
            self.titleLabel.leadingAnchor.constraint(equalTo: detailContainerView.leadingAnchor, constant: ViewsSpacing.inner),
            self.titleLabel.trailingAnchor.constraint(equalTo: detailContainerView.trailingAnchor, constant: -ViewsSpacing.inner),
            //Description label constraints
            self.descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ViewsSpacing.middle),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: detailContainerView.leadingAnchor, constant: ViewsSpacing.inner),
            self.descriptionLabel.bottomAnchor.constraint(equalTo: detailContainerView.bottomAnchor, constant: -ViewsSpacing.inner),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: detailContainerView.trailingAnchor, constant: -ViewsSpacing.inner),
            //Details constainer view constraints
            self.detailContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ViewsSpacing.outer),
            self.detailContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -ViewsSpacing.outer)
        ]
        NSLayoutConstraint.activate(constraints)
        //To adjust the image height
        self.imageViewHeight = self.factImageView.heightAnchor.constraint(equalTo: factImageView.widthAnchor, multiplier: ViewSizeRatios.image)
        self.imageViewBottomSpace = self.titleLabel.topAnchor.constraint(equalTo: factImageView.bottomAnchor, constant: ViewsSpacing.middle)
        //To adjst the top and button spaces
        self.detailContainerTopAnchorSpace = self.detailContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: ViewsSpacing.outer)
        self.detailContainerBottomAnchorSpace = self.detailContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -ViewsSpacing.outer)
        NSLayoutConstraint.activate([self.detailContainerTopAnchorSpace, self.detailContainerBottomAnchorSpace, self.imageViewHeight, self.imageViewBottomSpace])
        #if DEBUG
        print("\n\n\nLayout is activated\n\n\n")
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Prepared the FactsRowsTableViewCell with provided data
    func prepareTableViewCellWith(factData: Rows) {
        self.factsRowsTableViewCellVM = FactsRowsTableViewCellViewModel(factRow: factData)
        self.setUpUI()
    }
    
    //Customizes the factsrows tableview cell
    func setUpUI(){
        //When there is not data, am showing the custom message
        if self.factsRowsTableViewCellVM.isFactDataAvaiable{
            //UI updating
            self.titleLabel.text = self.factsRowsTableViewCellVM.title
            self.descriptionLabel.text = self.factsRowsTableViewCellVM.description
        }
        else{
            self.titleLabel.text = CustomMessages.noDetails
            self.descriptionLabel.text = ""
        }
        //Customizing the imagevuew >> Incase image url is not avaialble hiding the imageview from the tableview cell lese showing the respected image using url.
        self.factImageView.image = #imageLiteral(resourceName: "imageNotFound")
        if let imageUrl : URL = self.factsRowsTableViewCellVM.imageURL{
            //SDWebimageview customising
            self.factImageView.sd_setShowActivityIndicatorView(true)
            self.factImageView.sd_setIndicatorStyle(.gray)
            self.factImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "imageNotFound"), options: .queryDataWhenInMemory)
            //Deactivating image height and bottom sapce constaints and adding new constraints
            self.imageViewHeight.isActive = false
            self.imageViewBottomSpace.isActive = false
            self.imageViewHeight = self.factImageView.heightAnchor.constraint(equalTo: factImageView.widthAnchor, multiplier: ViewSizeRatios.image)
            self.imageViewBottomSpace = self.titleLabel.topAnchor.constraint(equalTo: factImageView.bottomAnchor, constant: ViewsSpacing.middle)
            NSLayoutConstraint.activate([self.imageViewHeight, self.imageViewBottomSpace])
        }
        else{
            //Deactivating image height and bottom sapce constaints and adding new constraints
            self.imageViewHeight.isActive = false
            self.imageViewBottomSpace.isActive = false
            self.imageViewHeight = self.factImageView.heightAnchor.constraint(equalToConstant: ViewsSpacing.zero)
            self.imageViewBottomSpace = self.titleLabel.topAnchor.constraint(equalTo: factImageView.bottomAnchor, constant: ViewsSpacing.zero)
            NSLayoutConstraint.activate([self.imageViewHeight, self.imageViewBottomSpace])
        }
    }
}

