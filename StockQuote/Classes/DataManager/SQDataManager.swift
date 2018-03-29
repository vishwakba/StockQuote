//
//  SQDataManager.swift
//  StockQuote
//
//  Created by Vishwak on 23/02/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import UIKit

class SQDataManager: NSObject {
    // MARK: - Singleton Instance
    fileprivate static let _database = SQDataManager()
    var list:[SQCompany] = []
    
    class func database() -> SQDataManager {
        return _database
    }
    
    override init() {
        super.init()
        
        if let path = Bundle.main.path(forResource: "CompaniesList", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [[String: AnyObject]] {
                    // do stuff
                    for item in jsonResult {
                        self.list.append(SQCompany.init(company: item))
                    }
                }
            } catch {
                // handle error
            }
        }
    }

}
