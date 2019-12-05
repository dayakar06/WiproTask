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
    
    init() {
        self.title = ""
        self.rows = [Rows]()
    }
    
    init(title: String, rows: [Rows]){
        self.title = title
        self.rows = rows
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try? values.decodeIfPresent(String.self, forKey: .title) ?? ""
        rows = try? values.decodeIfPresent([Rows].self, forKey: .rows) ?? [Rows]()
    }
}

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
    
    init(title: String?, description: String?, imagePath : String?) {
        self.title = title
        self.description = description
        self.imageHref = imagePath
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try? values.decodeIfPresent(String.self, forKey: .title) ?? ""
        description = try? values.decodeIfPresent(String.self, forKey: .description) ?? ""
        imageHref = try? values.decodeIfPresent(String.self, forKey: .imageHref) ?? ""
    }
}
