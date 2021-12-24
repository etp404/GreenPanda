//
//  GreenPandaModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 21/10/2020.
//

import Foundation

struct DiaryEntry {
    let id: UUID
    let timestamp: Date
    let entryText: String
    let score:Int
}

protocol GreenPandaModel {
    
    var entriesPublisher: Published<[DiaryEntry]>.Publisher { get }
    var entries: [DiaryEntry] { get }
    func add(entry: NewDiaryEntry)
    func deleteEntry(with id:UUID)
}


