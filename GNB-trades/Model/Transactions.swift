//
//  Transactions.swift
//  GNB-trades
//
//  Created by Christian Polo on 12/3/22.
//

import Foundation

struct Transaction: Codable {
    let sku: String
    let amount: String
    let currency: String
}
typealias Transactions = [Transaction]
