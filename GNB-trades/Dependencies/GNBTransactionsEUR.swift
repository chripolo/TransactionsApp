//
//  GNBTransactionsEUR.swift
//  GNB-trades
//
//  Created by Christian Polo on 13/3/22.
//

import Foundation

protocol TransactionsEUR {
    func fetch(res: @escaping (TransactionEUR?) -> Void)
}

struct GNBTransactionsEUR: TransactionsEUR{
    
    func fetch(res: @escaping (TransactionEUR?) -> Void) {
        let ratesFetcher = GNBRatesFetcher(networking: HTTPNetworking())
        let transactionsFetcher = GNBTransactionsFetcher(networking: HTTPNetworking())
        var rateList = NewRateList()
        var transactionList = NewTransactionList()
        ratesFetcher.fetch { response in
            DispatchQueue.main.async {
                guard let response = response else {
                    return
                }
                rateList = response
            }
        }
        
        transactionsFetcher.fetch { response in
            DispatchQueue.main.async {
                guard let response = response else {
                    return
                }
                transactionList = response
                res(transactionMatrixEUR(array: transactionList, rates: rateList))
            }
        }
        
    }
    private func transactionMatrixEUR(array: NewTransactionList, rates: NewRateList) -> TransactionEUR {
        
        var transactionList = TransactionEUR()
        for i in array{
            if transactionList.isEmpty{
                let value = TransactionToEUR()
                value.sku = i.sku
                for j in i.quantity {
                    let valueEUR = toEur(rates: rates, currency: j.currency, amount: j.amount)
                    value.quantity.append(.init(amountEUR: valueEUR))
                }
                transactionList.append(value)
            } else {
                let result = transactionList.filter({$0.sku == i.sku})
                if result.isEmpty {
                    let value = TransactionToEUR()
                    value.sku = i.sku
                    for j in i.quantity {
                        let valueEUR = toEur(rates: rates, currency: j.currency, amount: j.amount)
                        value.quantity.append(.init(amountEUR: valueEUR))
                    }
                    transactionList.append(value)
                } else {
                    let indice = transactionList.firstIndex(where: {$0.sku == i.sku})
                    for j in i.quantity {
                        let valueEUR = toEur(rates: rates, currency: j.currency, amount: j.amount)
                        transactionList[indice ?? 0].quantity.append(.init(amountEUR: valueEUR))
                    }
                }
            }
        }
        return transactionList
    }
    
    private func toEur (rates: NewRateList, currency: String, amount: String) -> Double{
        
        let amount = (amount as NSString).doubleValue
        
        guard currency != "EUR" else {
            let valueEur = 1 * amount
            return valueEur
        }
        
        let valueString = rates.filter({$0.from == "EUR"}).map({$0.conversion})[0].filter({$0.to == currency}).map({$0.rate})[0]
        let valueDouble = (valueString as NSString).doubleValue
        let valueTransformed = amount * valueDouble
        
        return valueTransformed
    }
    
}
