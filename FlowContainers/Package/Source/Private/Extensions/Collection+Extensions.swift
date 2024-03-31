//
//  Collection+Extensions.swift
//  FlowContainers
//
//  Created by Peter Schuette on 3/30/24.
//

import Foundation

extension Collection where Index == Int {
    /// Retrieve an element at a given index. If index is out of bounds, return nil
    /// - Parameter index: Index of desired element
    subscript(safe index: Int) -> Element? {
        guard (0..<count).contains(index) else { return nil }
        return self[index]
    }
    
    /// ``true`` if this collection contains any elements
    var isNotEmpty: Bool {
        !isEmpty
    }
}
