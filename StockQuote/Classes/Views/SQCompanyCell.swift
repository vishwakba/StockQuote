//
//  SQCompanyCell.swift
//  StockQuote
//
//  Created by Vishwak on 23/02/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import UIKit

class SQCompanyCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCellWithData(_ company: SQCompany) {
        self.textLabel?.text = company.name
        self.detailTextLabel?.text = company.symbol
    }
}
