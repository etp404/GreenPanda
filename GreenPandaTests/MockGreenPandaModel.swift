//
//  MockGreenPandaModel.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 04/11/2020.
//

import UIKit
@testable import GreenPanda

class MockGreenPandaModel : GreenPandaModel {
    func add(entry: DiaryEntry) {
        entries.append(entry)
    }
    
    var entries: [DiaryEntry] = []
}
