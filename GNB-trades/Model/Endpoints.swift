//
//  Endpoints.swift
//  GNB-trades
//
//  Created by Christian Polo on 12/3/22.
//
//
//import Foundation

protocol Endpoint {
  var path: String { get }
}

enum ServiceEndpoints {
    case rates
    case transaction
    
}
extension ServiceEndpoints: Endpoint {
    var path: String {
        switch self {
        case .rates:
            return "https://quiet-stone-2094.herokuapp.com/rates.json"
            
        case .transaction:
            return "https://quiet-stone-2094.herokuapp.com/transactions.json"
        }
    }
}
