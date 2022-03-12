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
            let rangeInt = -3*60*60..<3*60*60
            let randomElement: Int = Int.random(in: rangeInt)
            let randomDouble = Double(randomElement)
            return Date(timeIntervalSince1970: (Double(1642360072 + 24*60*60 * CoreDataGreenPandaModel.globalCount) + randomDouble))
        }
    }
}
