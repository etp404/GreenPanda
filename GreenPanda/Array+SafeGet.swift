//
//  Array+SafeGet.swift
//  GreenPanda
//
//  Created by Matthew Mould on 30/01/2022.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        let modifiedIndex = index >= 0 ? index : count+index
        return (modifiedIndex < count  && modifiedIndex >= 0) ? self[modifiedIndex] : nil
    }
}
