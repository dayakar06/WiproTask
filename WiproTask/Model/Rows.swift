//
//  Rows.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 20/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import Foundation

//Fact row structure
struct Rows : Codable {
    let title : String?
    let description : String?
    let imageHref : String?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case imageHref = "imageHref"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try? values.decodeIfPresent(String.self, forKey: .title) ?? ""
        description = try? values.decodeIfPresent(String.self, forKey: .description) ?? ""
        imageHref = try? values.decodeIfPresent(String.self, forKey: .imageHref) ?? ""
    }
}
