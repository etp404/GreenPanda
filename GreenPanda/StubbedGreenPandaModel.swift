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
    
    @Published var entriesBackingValue: [DiaryEntry] = [DiaryEntry(id: UUID(), timestamp: Date(), entryText: "Stubbed entry", score: 4)]

}
