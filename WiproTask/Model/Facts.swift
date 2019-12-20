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
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case rows = "rows"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try? values.decodeIfPresent(String.self, forKey: .title) ?? ""
        rows = try? values.decodeIfPresent([Rows].self, forKey: .rows) ?? [Rows]()
    }
}
