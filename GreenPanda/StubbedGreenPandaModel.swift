//
//  StubbedGreenPandaModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 27/10/2020.
//

import Combine
import UIKit

class StubbedGreenPandaModel : GreenPandaModel {
    var entries: Published<[DiaryEntry]>.Publisher {
        return $entriesBackingValue
    }
    
    func add(entry: DiaryEntry) {
        entriesBackingValue.append(entry)
    }
    
    @Published var entriesBackingValue: [DiaryEntry] = [DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah1", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah2", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah3", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah4", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah5", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah6", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah1", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah2", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah3", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah4", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah5", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah6", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah1", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah2", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah3", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah4", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah5", score: 4),
                                                        DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Blah blah6", score: 4)]

}
