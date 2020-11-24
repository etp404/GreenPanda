//
//  GreenPandaTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 21/10/2020.
//

import XCTest
import Combine

@testable import GreenPanda

class DiaryViewModelTests: XCTestCase {

    let entry1Text = "entry1Text"
    let entry2Text = "entry2Text"
    var mockGreenPandaModel: MockGreenPandaModel!
    var diaryViewModel: DiaryViewModel!
    var mockDiaryViewModelCoordinatorDelegate: MockDiaryViewModelCoordinatorDelegate!
    var cancellable: AnyCancellable?
    
    override func setUp() {
        self.continueAfterFailure = false;
        mockGreenPandaModel = MockGreenPandaModel()
        mockGreenPandaModel.entriesBackingValue = [
            DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1603645316), entryText: entry1Text, score: 1),
            DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1600642316), entryText: entry2Text, score: 2),
            DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1600642316), entryText: entry2Text, score: 3),
            DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1600642316), entryText: entry2Text, score: 4),
            DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1600642316), entryText: entry2Text, score: 5)]
        mockDiaryViewModelCoordinatorDelegate = MockDiaryViewModelCoordinatorDelegate()

        diaryViewModel = DiaryViewModel(model: mockGreenPandaModel,
                                        timezone: TimeZone.init(abbreviation: "CET")!,
                                        coordinatorDelegate: mockDiaryViewModelCoordinatorDelegate)
        
    }
    
    func testThatExpectedNNumberEntriesAreReturned() throws {
        XCTAssertEqual(diaryViewModel.entries.count, 5)
    }
    
    func testThatExpectedIdsAreReturned() throws {
        
        XCTAssertEqual(diaryViewModel.entries[0].id, mockGreenPandaModel.entriesBackingValue[0].id)
        XCTAssertEqual(diaryViewModel.entries[1].id, mockGreenPandaModel.entriesBackingValue[1].id)
    }
    
    func testThatExpectedEntryTextsAreReturned() throws {
        
        XCTAssertEqual(diaryViewModel.entries[0].entryText, entry1Text)
        XCTAssertEqual(diaryViewModel.entries[1].entryText, entry2Text)
    }
    
    func testThatExpectedEntryDatesAreReturned() throws {
        XCTAssertEqual(diaryViewModel.entries[0].date, "Sun, 25 Oct 2020 18:01")
        XCTAssertEqual(diaryViewModel.entries[1].date, "Mon, 21 Sep 2020 00:51")
    }
    
    func testThatExpectedScoreIsReturnedAsEpected() throws {
        XCTAssertEqual(diaryViewModel.entries[0].score, "😩")
        XCTAssertEqual(diaryViewModel.entries[1].score, "😕")
        XCTAssertEqual(diaryViewModel.entries[2].score, "😐")
        XCTAssertEqual(diaryViewModel.entries[3].score, "🙂")
        XCTAssertEqual(diaryViewModel.entries[4].score, "😁")
    }
    
    func testThatPressingTheComposeButtonOpensTheComposeView() {
        diaryViewModel.composeButtonPressed()
        
        XCTAssertTrue(mockDiaryViewModelCoordinatorDelegate.openComposeViewInvoked)
    }
    
    func testThatValuesOnTheViewModelCanBeSubscribedTo() {
        var receivedValue: [EntryViewModel]? = nil
        cancellable = diaryViewModel.$entries.sink { value in
            receivedValue = value
        }
        
        XCTAssertEqual(receivedValue?.count, 5)
    }
    
    func testThatUpdatesToTheModelArePickedUpAndPropagatedByTheViewModel() {
        var receivedValue: [EntryViewModel]? = nil
        cancellable = diaryViewModel.$entries.sink { value in
            receivedValue = value
        }
        
        mockGreenPandaModel.add(entry: DiaryEntry(id: UUID(), timestamp: Date(), entryText: "abc", score: 0))
        
        XCTAssertEqual(receivedValue?.count, 6)
    }


}

class MockDiaryViewModelCoordinatorDelegate : DiaryViewModelCoordinatorDelegate {
    var openComposeViewInvoked = false
    
    func openComposeView() {
        openComposeViewInvoked = true
    }
}
    
