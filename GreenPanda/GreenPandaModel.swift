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
}

protocol GreenPandaModel {
    var entries: [DiaryEntry] { get }
}


