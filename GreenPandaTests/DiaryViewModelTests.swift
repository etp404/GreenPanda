//
//  GreenPandaTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 21/10/2020.
//

import XCTest
@testable import GreenPanda

class DiaryViewModelTests: XCTestCase {

    override func setUp() {
        self.continueAfterFailure = false;
    }
    
    func testThatExpectedNNumberEntriesAreReturned() throws {
        let mockGreenPandaModel = MockGreenPandaModel()
        mockGreenPandaModel.entries = [DiaryEntry(entryText: ""), DiaryEntry(entryText: "")]
        let diarViewModel = DiaryViewModel(model: mockGreenPandaModel)
        XCTAssertEqual(diarViewModel.numberOfEntries, 2)
    }
    
    func testThatExpectedEntriesAreReturned() throws {
        let mockGreenPandaModel = MockGreenPandaModel()
        let entry1Text = "entry1Text"
        let entry2Text = "entry2Text"
        mockGreenPandaModel.entries = [DiaryEntry(entryText: entry1Text), DiaryEntry(entryText: entry2Text)]
        let diarViewModel = DiaryViewModel(model: mockGreenPandaModel)
        
        XCTAssertEqual(diarViewModel.entryViewModels.count, 2)
        XCTAssertEqual(diarViewModel.entryViewModels[0].entryText, entry1Text)
        XCTAssertEqual(diarViewModel.entryViewModels[1].entryText, entry2Text)
    }
    
}

class MockGreenPandaModel : GreenPandaModel {
    var entries: [DiaryEntry] = []
}
