//
//  Rates.swift
//  GNB-trades
//
//  Created by Christian Polo on 12/3/22.
//

import Foundation

struct Rate: Codable {
        let from: String
        let to: String
        let rate: String
}
typealias Rates = [Rate]
