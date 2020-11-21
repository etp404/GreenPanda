//
//  StubbedGreenPandaModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 27/10/2020.
//

import UIKit

class StubbedGreenPandaModel : GreenPandaModel {
    func add(entry: DiaryEntry) {
        entriesBackingValue.append(entry)
    }
    
    var entriesBackingValue: [DiaryEntry] = [DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4),
                                 DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4),
                                 DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4),
                                 DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4),
                                 DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4),
                                 DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4),
                                 DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4)]

    
}
