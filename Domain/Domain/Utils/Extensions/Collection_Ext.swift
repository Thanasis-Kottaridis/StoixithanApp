//
//  Collections_Ext.swift
//  Domain
//
//  Created by thanos kottaridis on 4/2/23.
//

import Foundation

public extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}
