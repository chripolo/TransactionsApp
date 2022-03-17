//
//  TransactionEUR.swift
//  GNB-trades
//
//  Created by Christian Polo on 13/3/22.
//

import Foundation

class TransactionToEUR {
    var sku: String = ""
    
    struct Quantity {
        let amountEUR: Double
        let currency = "€"
    }
    var quantity : [Quantity] = []
}
typealias TransactionEUR = [TransactionToEUR]
