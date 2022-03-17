//
//  TransactionsViewController.swift
//  GNB-trades
//
//  Created by Christian Polo on 12/3/22.
//

import UIKit

class TransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var productSelected = [TransactionToEUR.Quantity]()
    var skuName: String?
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var tableTransactions: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableTransactions.dataSource = self
        tableTransactions.delegate = self
        
        productName.text = skuName
        let sum = productSelected.map({$0.amountEUR}).reduce(0,+).hundredthsToString()
        total.text = "\(sum)€"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productSelected.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTransaction", for: indexPath) as! TransactionTableViewCell
        
        cell.selectionStyle = .none
        
        let currency = productSelected[indexPath.row].currency
        let valueCurrency = productSelected[indexPath.row].amountEUR
        
        let currencyToShow = valueCurrency.hundredthsToString()
        
        cell.amount.text = "\(currencyToShow) \(currency)"
        cell.sale.text = "Sale Nº \(indexPath.row+1)"
        
        return cell
    }
}
