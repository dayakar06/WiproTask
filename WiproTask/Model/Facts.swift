//
//  Facts.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 04/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import Foundation

//To store the facts details with codeable protocal, so that we can use for while parsing data.
struct Facts : Codable {
    let title : String?
    let rows : [Rows]?
}
