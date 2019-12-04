//
//  APIHelper.swift
//  WiproTask
//
//  Created by Dayakar Reddy on 04/12/19.
//  Copyright © 2019 dayakar. All rights reserved.
//

import Foundation

class APIHelper: NSObject {
    
    static let shared = APIHelper()
    
    //Get API call
    func codableGetRequestWith(apiName: String, headers: [String:String]?, completionHandler: @escaping (Bool, Data?, String) -> Void) {
        print("\n\n\n")
        print("GET")
        print("apiName = \(apiName)")
        print("headers = ",headers ?? "")
        print("\n\n\n")
        //Creating request
        var request = URLRequest(url: URL(string: apiName)!)
        //Adding request type
        request.httpMethod = "GET"
        //Adding request Headers
        if headers!.count > 0{
            request.allHTTPHeaderFields = headers
        }
        //Adding request time
        request.timeoutInterval = 120
        //Creating the dataTask using the URLSession, requst process with given data.
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if error != nil || data == nil {
                #if DEBUG
                    print("\(apiName) error = ",error?.localizedDescription ?? CustomMessages.defaultResponseError)
                #endif
                completionHandler(false, nil, error?.localizedDescription ?? CustomMessages.defaultResponseError)
                return
            }
            else{                
                let responseStrInISOLatin = String(data: data ?? Data(), encoding: String.Encoding.isoLatin1)
                guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                    print("could not convert data to UTF-8 format")
                    return
                }
                completionHandler(true,modifiedDataInUTF8Format,"Success")
            }
        })
        task.resume()
    }
}
