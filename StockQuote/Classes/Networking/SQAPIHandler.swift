//
//  SQAPIHandler.swift
//  StockQuote
//
//  Created by Vishwak on 23/02/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import Foundation

typealias CompletionBlock = (_ result: [String: AnyObject]?,_ error: Error?) -> Void


class SQAPIHandler: NSObject {

    class func authenticateTPTOAuth2(_ completion: @escaping CompletionBlock) -> URLSessionDataTask {
        let client = SQAPIClient.shared()
        let parameter: [String: String] = [
            "client_id" : client.clientId,
            "client_secret" : client.clientSecret,
            "grant_type" : client.grantType
            ];
        return client.requestWithPath("oauth/token", method: .POST, parameter: parameter) {
            (data, error) in
            do {
                if data != nil {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
                    SQAPIClient.shared().accessToken = json["access_token"] as? String
                    completion(json, nil)
                } else {
                    completion(nil, error)
                }
            } catch {
                completion(nil, error)
            }
        }
    }
    
    class func fetchCompanyQuote(_ symbol: String, completion: @escaping CompletionBlock) -> URLSessionDataTask {
        let client = SQAPIClient.shared()
        let parameter: [String: String] = [:];
        return client.requestWithPath("v1/market/symbols/\(symbol)/quote", parameter: parameter) {
            (data, error) in
            do {
                if data != nil {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
                    completion(json, nil)
                } else {
                    completion(nil, error)
                }
            } catch {
                completion(nil, error)
            }
        }
    }
}
