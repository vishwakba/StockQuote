//
//  SQDetailViewController.swift
//  StockQuote
//
///  Created by Vishwak on 23/02/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import UIKit
import SVProgressHUD

class SQDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var company:SQCompany?
    var list:[Any] = []
    
    @IBOutlet weak var contentTableView: UITableView!
    
    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = self.company?.symbol
        
        self.authenticate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data Methods

    func authenticate() {
        SVProgressHUD.show(withStatus: "Fetching Details...")
        if (SQAPIClient.shared().accessToken != nil) {
            self.fetchCompanyQuote()
        } else {
            //Authenticate TPT OAuth2 for getting detailed Stock qutoes
            _ = SQAPIHandler.authenticateTPTOAuth2 { (response, error) in
                if (response != nil) {
//                    print("response: \(response!)")
                    self.fetchCompanyQuote()
                } else if (error != nil) {
//                    print("error: \(error!)")
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
            }
        }
    }
    
    func fetchCompanyQuote() {
        _ = SQAPIHandler.fetchCompanyQuote(self.title!) { (response, error) in
            if (response != nil) {
                SVProgressHUD.dismiss()
//                print("response: \(response!)")
                var section1 = Array<Any>()
                if let exchange = response!["exchange"] {
                    section1.append(["title": "Exchange", "value": exchange])
                }
                
                if let company_name = response!["company_name"] {
                    section1.append(["title": "Company Name", "value": company_name])
                }
                
                if let asset_type = response!["asset_type"] {
                    section1.append(["title": "Asset Type", "value": asset_type])
                }
                
                if let exchange_name = response!["exchange_name"] {
                    section1.append(["title": "Exchange Name", "value": exchange_name])
                }
                
                if (section1.count > 0) {
                    self.list.append(["title": "Stock Quote", "value": section1])
                }
                
                if let fundamental = response!["fundamental"] {
                    var section2 = Array<Any>()
                    
                    let eps = (fundamental["eps"])!
                    section2.append(["title": "Eps", "value": eps!])
                    
                    let market_cap = (fundamental["market_cap"])!
                    section2.append(["title": "Market Cap", "value": market_cap!])
                    
                    let pb_ratio = (fundamental["pb_ratio"])!
                    section2.append(["title": "Pb Ratio", "value": pb_ratio!])
                    
                    let pe_ratio = (fundamental["pe_ratio"])!
                    section2.append(["title": "Pe Ratio", "value": pe_ratio!])
                    
                    let shares_escrow = (fundamental["shares_escrow"])!
                    section2.append(["title": "Shares Escrow", "value": shares_escrow!])
                    
                    let shares_outstanding = (fundamental["shares_outstanding"])!
                    section2.append(["title": "Shares Outstanding", "value": shares_outstanding!])
                    
                    if (section2.count > 0) {
                        self.list.append(["title": "Fundamental", "value": section2])
                    }
                }
                
                if let price = response!["price"] {
                    var section3 = Array<Any>()
                    
                    let ask = price["ask"] as! [String: AnyObject]
                    let bid = price["bid"] as! [String: AnyObject]
                    
                    let ask_price = (ask["price"])!
                    section3.append(["title": "Ask Price", "value": ask_price])
                    
                    let ask_size = (ask["size"])!
                    section3.append(["title": "Ask Size", "value": ask_size])
                    
                    let bid_price = (bid["price"])!
                    section3.append(["title": "Bid Price", "value": bid_price])
                    
                    let bid_size = (bid["size"])!
                    section3.append(["title": "Bid Size", "value": bid_size])
                    
                    let change = (price["change"])!
                    section3.append(["title": "Change", "value": change!])
                    
                    let change_percent = (price["change_percent"])!
                    section3.append(["title": "Change Percent", "value": change_percent!])
                    
                    let high = (price["high"])!
                    section3.append(["title": "High", "value": high!])
                    
                    let last_price = (price["last_price"])!
                    section3.append(["title": "Last Price", "value": last_price!])
                    
                    let low = (price["low"])!
                    section3.append(["title": "Low", "value": low!])
                    
                    let open = (price["open"])!
                    section3.append(["title": "Open", "value": open!])
                    
                    let prev_close = (price["prev_close"])!
                    section3.append(["title": "Prev Close", "value": prev_close!])
                    
                    let share_volume = (price["share_volume"])!
                    section3.append(["title": "Share Volume", "value": share_volume!])
                    
                    let trade_volume = (price["trade_volume"])!
                    section3.append(["title": "Trade Volume", "value": trade_volume!])
                    
                    let vwap = (price["vwap"])!
                    section3.append(["title": "Vwap", "value": vwap!])
                    
                    if (section3.count > 0) {
                        self.list.append(["title": "Price", "value": section3])
                    }
                }
//                print("List: \(self.list)")
                self.contentTableView.reloadData()
            } else if (error != nil) {
//                print("error: \(error!)")
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    // MARK: - UITableView Delegate & DataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.list[section] as! [String: AnyObject]
        let rows = section["value"] as? [Any] ?? []
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.list[section] as! [String: AnyObject]
        return section["title"] as? String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "DetailCell")
            cell?.selectionStyle = .none
        }
        let section = self.list[indexPath.section] as! [String: AnyObject]
        let rows = section["value"] as! [Any]
        let dict = rows[indexPath.row] as! [String: AnyObject]
        cell?.textLabel?.text = dict["title"] as? String
        cell?.detailTextLabel?.text = "\((dict["value"])!)"
        return cell!
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
