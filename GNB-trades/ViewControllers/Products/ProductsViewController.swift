//
//  ViewController.swift
//  GNB-trades
//
//  Created by Christian Polo on 12/3/22.
//

import UIKit

internal class ProductsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableProducts: UITableView!

    let transactionsEUR = GNBTransactionsEUR()
    var transactionListEUR = TransactionEUR()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTransactionsEUR()
        tableProducts.delegate = self
        tableProducts.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionListEUR.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellProduct", for: indexPath) as! ProductTableViewCell
        
        cell.accessoryType = .disclosureIndicator
        cell.product.text = transactionListEUR[indexPath.row].sku
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pasando información a TransactionsViewController
        guard let celda = sender as? UITableViewCell,
              let index = tableProducts.indexPath(for: celda) else {
                  return
              }
        
        if segue.identifier == "toTransactionList"{
            guard let destination = segue.destination as? TransactionsViewController else {
                return
            }
            destination.productSelected = transactionListEUR[index.row].quantity
            destination.skuName = transactionListEUR[index.row].sku
        }
    }
    
    private func requestTransactionsEUR() {
        transactionsEUR.fetch { response in
            guard let response = response else {
                return
            }
            self.transactionListEUR = response
            self.tableProducts.reloadData()
        }
    }
}
