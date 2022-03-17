//
//  NewTransactionList.swift
//  GNB-trades
//
//  Created by Christian Polo on 12/3/22.
//

import Foundation

class TransactionList {
    var sku: String = ""
    struct Quantity {
        let currency: String
        let amount: String
    }
    var quantity : [Quantity] = []
}
typealias NewTransactionList = [TransactionList]

