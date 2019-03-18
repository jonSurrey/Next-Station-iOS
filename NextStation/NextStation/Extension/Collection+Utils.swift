//
//  Collection+Utils.swift
//  NextStation
//
//  Created by Jonathan Martins on 26/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Get object at especific index
    ///
    /// - Parameter index: Index of object
    /// - Returns: Element at index or nil
    func element(at index: Index) -> Iterator.Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}
