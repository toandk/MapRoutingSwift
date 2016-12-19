//
//  APIRequest.swift
//  aBooks
//
//  Created by Appdaily on 7/16/16.
//  Copyright © 2016 com. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public typealias APIResponseBlock = (error: NSError?, object: JSON?) -> Void
public typealias APICacheResponseBlock = (error: NSError?, object: JSON?, cache: Bool) -> Void

class APIRequest: NSObject {
    
    static func requestWithUrl(url: String, param: [String: AnyObject]?, method: String, completion: APIResponseBlock) {
        var methodRequest = Method.GET
        debugPrint("- API: \(url)")
        debugPrint("- Method: " + method)
        debugPrint("- Params: \(param)")
        
        if method == "GET" {
            methodRequest = .GET
        }
        else if method == "POST" {
            methodRequest = .POST
        }
        else if method == "DELETE" {
            methodRequest = .DELETE
        }
        else if method == "PUT" {
            methodRequest = .PUT
        }
        
        Alamofire.request(methodRequest, url, parameters: param, headers: nil)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        completion(error: nil, object: json)
                    }
                case .Failure(let error):
                    completion(error: error, object: nil)
                }
        }
    }
}
