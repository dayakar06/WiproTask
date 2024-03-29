//
//  Constants.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 04/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import Foundation
import UIKit

//APIs
struct APIs {
    static let facts = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
}

struct HTTPHeaders {
    static let contentTypeJson = ["Content-Type": "application/json"]
}

//Custom messages
struct CustomMessages {
    static let empty = ""
    static let noInternet = "No internet connect. Please check internet connection and Please try again!"
    static let noData = "No data available,\nPull down to refresh the data...!"
    static let defaultResponseError = "Something went wrong, Please try again!"
    static let dataConversionError = "Could not convert data to UTF-8 format"
    static let dataParseError = "Something went wrong while data parsing, Plese try again!"
    static let noDetails = "Details are not available for this fact"
    static let refreshing = "Fetching Updated Details..."
}

//Constarints constant size values
struct ViewsSpacing{
    static let zero : CGFloat = 0
    static let middle : CGFloat = 5.0
    static let inner : CGFloat = 8.0
    static let outer : CGFloat = 10.0
}

//Corner radius
struct CornerRadius {
    static let _default : CGFloat = 5.0
}

//View size ratios
struct ViewSizeRatios{
    static let image : CGFloat = 2.1/4.0
    static let _default : CGFloat = 1.0
}

//Fonts sizes
struct FontSize{
    static let s26 : CGFloat = 26.0
    static let s20 : CGFloat = 20.0
    static let s17 : CGFloat = 17.0
    static let s15 : CGFloat = 15.0
}

//Label text lines
struct LabelTextLines {
    static let zero = 0
}

//Test expectation time interval
struct TestExpectionTime {
    static let short = TimeInterval.init(5.0)
}

