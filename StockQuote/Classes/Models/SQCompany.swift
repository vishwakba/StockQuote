//
//  SQCompany.swift
//  StockQuote
//
//  Created by Vishwak on 23/02/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import UIKit

class SQCompany: NSObject {

    let symbol: String?
    let name: String?

    init(company: [String: AnyObject]) {
        self.symbol = "\((company["Symbol"])!)"
        self.name = company["Name"] as? String
    }
}
