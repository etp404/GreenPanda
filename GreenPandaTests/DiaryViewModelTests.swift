//
//  GreenPandaTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 21/10/2020.
//

import XCTest
@testable import GreenPanda

class DiaryViewModelTests: XCTestCase {

    let entry1Text = "entry1Text"
    let entry2Text = "entry2Text"
    let mockGreenPandaModel = MockGreenPandaModel()

    override func setUp() {
        self.continueAfterFailure = false;
        mockGreenPandaModel.entries = [DiaryEntry(timestamp: Date(timeIntervalSince1970: 1603645316), entryText: entry1Text, score: 1),
                                       DiaryEntry(timestamp: Date(timeIntervalSince1970: 1600642316), entryText: entry2Text, score: 2),
                                       DiaryEntry(timestamp: Date(timeIntervalSince1970: 1600642316), entryText: entry2Text, score: 3),
                                       DiaryEntry(timestamp: Date(timeIntervalSince1970: 1600642316), entryText: entry2Text, score: 4),
                                       DiaryEntry(timestamp: Date(timeIntervalSince1970: 1600642316), entryText: entry2Text, score: 5)]
    }
    
    func testThatExpectedNNumberEntriesAreReturned() throws {
        let diarViewModel = DiaryViewModel(model: mockGreenPandaModel)
        XCTAssertEqual(diarViewModel.numberOfEntries, 5)
    }
    
    func testThatExpectedEntryTextsAreReturned() throws {
        let diarViewModel = DiaryViewModel(model: mockGreenPandaModel)
        
        XCTAssertEqual(diarViewModel.entryViewModels[0].entryText, entry1Text)
        XCTAssertEqual(diarViewModel.entryViewModels[1].entryText, entry2Text)
    }
    
    func testThatExpectedEntryDatesAreReturned() throws {
        let diaryViewModel = DiaryViewModel(model: mockGreenPandaModel)
        
        XCTAssertEqual(diaryViewModel.entryViewModels[0].date, "Sun, 25 Oct 2020 17:01")
        XCTAssertEqual(diaryViewModel.entryViewModels[1].date, "Sun, 20 Sep 2020 23:51")
    }
    
    func testThatExpectedScoreIsReturnedAsEpected() throws {
        let diaryViewModel = DiaryViewModel(model: mockGreenPandaModel)
        
        XCTAssertEqual(diaryViewModel.entryViewModels[0].score, "😩")
        XCTAssertEqual(diaryViewModel.entryViewModels[1].score, "😕")
        XCTAssertEqual(diaryViewModel.entryViewModels[2].score, "😐")
        XCTAssertEqual(diaryViewModel.entryViewModels[3].score, "🙂")
        XCTAssertEqual(diaryViewModel.entryViewModels[4].score, "😁")
    }
    
}

class MockGreenPandaModel : GreenPandaModel {
    var entries: [DiaryEntry] = []
}
