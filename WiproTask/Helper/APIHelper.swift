//
//  APIHelper.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 04/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import Foundation

protocol APIHelperProtocol {
    func codableGetRequestWith(apiName: String, headers: [String:String]?, completionHandler: @escaping (Bool, Facts?, String) -> Void)
}

class APIHelper: APIHelperProtocol{
    
    //API request
    var request : URLRequest!
    
    //Reachablitily to check the internet connection
    let reachability = Reachability()!
    
    //MARK:- Get API call
    func codableGetRequestWith(apiName: String, headers: [String:String]?, completionHandler: @escaping (Bool, Facts?, String) -> Void) {
        #if DEBUG
            print("\n\n\n")
            print("GET")
            print("apiName = \(apiName)")
            print("headers = ",headers ?? "")
            print("\n\n\n")
        #endif
        if !reachability.isReachable{
            completionHandler(false, nil, CustomMessages.noInternet)
            return
        }
        //Creating request
        self.request = URLRequest(url: URL(string: apiName)!)
        //Adding request type
        self.request.httpMethod = "GET"
        //Adding request Headers
        if headers!.count > 0{
            self.request.allHTTPHeaderFields = headers
        }
        //Adding request time
        self.request.timeoutInterval = 120
        //Creating the dataTask using the URLSession, requst process with given data.
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if error != nil || data == nil {
                #if DEBUG
                    print("\(apiName) error = ",error?.localizedDescription ?? CustomMessages.defaultResponseError)
                #endif
                completionHandler(false, nil, error?.localizedDescription ?? CustomMessages.defaultResponseError)
            }
            else{
                let responseStrInISOLatin = String(data: data ?? Data(), encoding: String.Encoding.isoLatin1)
                guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                    completionHandler(true, nil, CustomMessages.dataConversionError)
                    return
                }
                guard let facts : Facts = try? JSONDecoder().decode(Facts.self, from: modifiedDataInUTF8Format) else{
                    completionHandler(true, nil, CustomMessages.dataParseError)
                    return
                }
                completionHandler(true, facts, "Success")
            }
        }).resume()
    }
}
