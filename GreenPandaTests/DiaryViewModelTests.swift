//
//  GreenPandaTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 21/10/2020.
//

import XCTest
@testable import GreenPanda

class DiaryViewModelTests: XCTestCase {

    func testThatExpectedEntriesAreReturned() throws {
        let mockGreenPandaModel = MockGreenPandaModel()
        mockGreenPandaModel.entries = [DiaryEntry(), DiaryEntry()]
        let diarViewModel = DiaryViewModel(model: mockGreenPandaModel)
        XCTAssertEqual(diarViewModel.numberOfEntries, 2)
    }
    
}

class DiaryViewModel {
    
    private let greenPandaModel: GreenPandaModel
    
    init(model greenPandaModel: GreenPandaModel) {
        self.greenPandaModel = greenPandaModel
    }
    
    var numberOfEntries:Int {
        greenPandaModel.entries.count
    }
}

struct DiaryEntry {}

protocol GreenPandaModel {
    var entries: [DiaryEntry] { get }
}

class MockGreenPandaModel : GreenPandaModel {
    var entries: [DiaryEntry] = []
}
