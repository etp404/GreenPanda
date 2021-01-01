//
//  TimeProvider.swift
//  GreenPanda
//
//  Created by Matthew Mould on 01/01/2021.
//

import Foundation

public protocol Clock {
    var date: Date { get }
}

public struct DateClock : Clock {
    public var date: Date {
        get {
            Date()
        }
    }
}
