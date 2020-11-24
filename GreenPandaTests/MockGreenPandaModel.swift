//
//  MockGreenPandaModel.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 04/11/2020.
//

import UIKit
@testable import GreenPanda

class MockGreenPandaModel : GreenPandaModel {
    var entries: Published<[DiaryEntry]>.Publisher {
        return $entriesBackingValue
    }
    
    func add(entry: DiaryEntry) {
        entriesBackingValue.append(entry)
    }
    
    @Published var entriesBackingValue: [DiaryEntry] = []
}
