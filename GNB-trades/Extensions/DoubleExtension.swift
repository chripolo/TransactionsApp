//
//  DoubleExtension.swift
//  GNB-trades
//
//  Created by Christian Polo on 17/3/22.
//

import Foundation

extension Double {
    
    private func roundHalfToEven(size: Int) -> Double {
        let divisor = pow(10.0, Double(size))
        return (self * divisor).rounded() / divisor
    }
    
    func hundredthsToString() -> String{
        return String(format: "%.2f", self.roundHalfToEven(size: 2))
    }
}
