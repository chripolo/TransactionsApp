//
//  ArrayExtension.swift
//  GNB-trades
//
//  Created by Christian Polo on 17/3/22.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
