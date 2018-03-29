//
//  SQListViewController.swift
//  StockQuote
//
//  Created by Vishwak on 23/02/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import UIKit

class SQListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentTableView: UITableView!
    var list:[SQCompany] = SQDataManager.database().list

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableView Delegate & DataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SQCompanyCell", for: indexPath) as! SQCompanyCell
        cell.updateCellWithData(list[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SQDetailViewController") as! SQDetailViewController
        viewController.company = self.list[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

