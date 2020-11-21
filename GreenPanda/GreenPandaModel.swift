//
//  GreenPandaModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 21/10/2020.
//

import Foundation

struct DiaryEntry {
    let timestamp: Date
    let entryText: String
    let score:Int
}

protocol GreenPandaModel {
    
    var entriesBackingValue: [DiaryEntry] { get }
    
    func add(entry: DiaryEntry)
}


