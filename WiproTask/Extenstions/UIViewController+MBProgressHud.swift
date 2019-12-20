//
//  ViewController+MBProgressHud.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 17/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIViewController {
    func showIndicator(withTitle title: String? = nil, and Description: String? = nil) {
        let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        Indicator.label.text = title
        Indicator.isUserInteractionEnabled = false
        Indicator.detailsLabel.text = Description
        DispatchQueue.main.async{
            Indicator.show(animated: true)
        }
    }
    
    func hideIndicator() {
        DispatchQueue.main.async{
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
