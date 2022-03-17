//
//  GNBTransactionsFetcher.swift
//  GNB-trades
//
//  Created by Christian Polo on 12/3/22.
//

import Foundation

protocol TransactionsFetcher {
    func fetch(response: @escaping (NewTransactionList?) -> Void)
}

struct GNBTransactionsFetcher: TransactionsFetcher {
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func fetch(response: @escaping (NewTransactionList?) -> Void) {
        networking.request(from: ServiceEndpoints.transaction) { data, error in
            if let error = error {
                print("Error received requesting Rates: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: Transactions.self, from: (data as! Data))
            if let decoded = decoded {
                response(transactionMatrix(array: decoded))
            }
        } 
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from,
              let response = try? decoder.decode(type.self, from: data) else { return nil }
        
        return response
    }
    
    private func transactionMatrix(array: Transactions) -> NewTransactionList {
        
        var transactionList = NewTransactionList()
        for i in array{
            if transactionList.isEmpty{
                let value = TransactionList()
                value.sku = i.sku
                value.quantity.append(.init(currency: i.currency, amount: i.amount))
                transactionList.append(value)
            } else {
                let result = transactionList.filter({$0.sku == i.sku})
                if result.isEmpty {
                    let value = TransactionList()
                    value.sku = i.sku
                    value.quantity.append(.init(currency: i.currency, amount: i.amount))
                    transactionList.append(value)
                } else {
                    let indice = transactionList.firstIndex(where: {$0.sku == i.sku})
                    transactionList[indice ?? 0].quantity.append(.init(currency: i.currency, amount: i.amount))
                }
            }
        }
        return transactionList
    }
}
