//
//  MockGreenPandaModel.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 04/11/2020.
//

import UIKit
@testable import GreenPanda

class MockGreenPandaModel : GreenPandaModel {
    var date:Date = Date()
    var capturedIdToDelete: UUID?
    var entries: Published<[DiaryEntry]>.Publisher {
        return $entriesBackingValue
    }
    
    func add(entry: NewDiaryEntry) {
        entriesBackingValue.append(DiaryEntry(id: entry.id, timestamp: date, entryText: entry.entryText, score: entry.score))
    }
    
    func deleteEntry(with id:UUID) {
        capturedIdToDelete = id
    }
    
    @Published var entriesBackingValue: [DiaryEntry] = []
}
