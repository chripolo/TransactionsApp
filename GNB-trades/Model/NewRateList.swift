//
//  NewRateList.swift
//  GNB-trades
//
//  Created by Christian Polo on 12/3/22.
//

import Foundation

class RateList {
    var from: String = ""
    struct Conversion {
        let to: String
        let rate: String
    }
    var conversion : [Conversion] = []
}
typealias NewRateList = [RateList]
