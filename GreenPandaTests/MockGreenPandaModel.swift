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
    var entriesPublisher: Published<[DiaryEntry]>.Publisher {
        return $entries
    }
    
    func add(entry: NewDiaryEntry) {
        entries.append(DiaryEntry(id: entry.id, timestamp: date, entryText: entry.entryText, score: entry.score))
    }
    
    func deleteEntry(with id:UUID) {
        capturedIdToDelete = id
    }
    
    @Published var entries: [DiaryEntry] = []
}
