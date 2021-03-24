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
    let entry0Id = UUID()
    let entry1Id = UUID()
    let entry2Id = UUID()
    let entry3Id = UUID()
    let entry4Id = UUID()


    override func setUp() {
        self.continueAfterFailure = false;
        mockGreenPandaModel = MockGreenPandaModel()
        mockGreenPandaModel.entriesBackingValue = [
            DiaryEntry(id: entry4Id, timestamp: Date(timeIntervalSince1970: 1603645315), entryText: entry1Text, score: 5),
            DiaryEntry(id: entry2Id, timestamp: Date(timeIntervalSince1970: 1600642313), entryText: entry2Text, score: 3),
            DiaryEntry(id: entry1Id, timestamp: Date(timeIntervalSince1970: 1600642312), entryText: entry2Text, score: 2),
            DiaryEntry(id: entry3Id, timestamp: Date(timeIntervalSince1970: 1600642314), entryText: entry2Text, score: 4),
            DiaryEntry(id: entry0Id, timestamp: Date(timeIntervalSince1970: 1600642311), entryText: entry2Text, score: 1)]
        mockDiaryViewModelCoordinatorDelegate = MockDiaryViewModelCoordinatorDelegate()

        diaryViewModel = DiaryViewModel(model: mockGreenPandaModel,
                                        timezone: TimeZone.init(abbreviation: "CET")!,
                                        coordinatorDelegate: mockDiaryViewModelCoordinatorDelegate)
        
    }
    
    func testThatExpectedNNumberEntriesAreReturned() throws {
        XCTAssertEqual(diaryViewModel.entries.count, 5)
    }
    
    func testThatExpectedIdsAreReturnedInOrder() throws {
        
        XCTAssertEqual(entry4Id, diaryViewModel.entries[0].id)
        XCTAssertEqual(entry3Id, diaryViewModel.entries[1].id)
        XCTAssertEqual(entry2Id, diaryViewModel.entries[2].id)
        XCTAssertEqual(entry1Id, diaryViewModel.entries[3].id)
        XCTAssertEqual(entry0Id, diaryViewModel.entries[4].id)

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
        XCTAssertEqual(diaryViewModel.entries[0].score, "😁")
        XCTAssertEqual(diaryViewModel.entries[1].score, "🙂")
        XCTAssertEqual(diaryViewModel.entries[2].score, "😐")
        XCTAssertEqual(diaryViewModel.entries[3].score, "😕")
        XCTAssertEqual(diaryViewModel.entries[4].score, "😩")
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
        
        mockGreenPandaModel.add(entry: NewDiaryEntry(id: UUID(), entryText: "abc", score: 0))
        
        XCTAssertEqual(receivedValue?.count, 6)
    }

    func testThatChartDataAreReturned() {
        XCTAssertEqual(diaryViewModel.chartData.count, 5)

        XCTAssertEqual(diaryViewModel.chartData[0].timestamp,1600642311)
        XCTAssertEqual(diaryViewModel.chartData[0].moodScore,1)

        XCTAssertEqual(diaryViewModel.chartData[4].timestamp, 1603645315)
        XCTAssertEqual(diaryViewModel.chartData[4].moodScore, 5)
    }

    func testThatCorrectChartRangeIsReturnedFromViewModel() {
        XCTAssertEqual(diaryViewModel.chartVisibleRange, 7*24*60*60)
    }

}

class MockDiaryViewModelCoordinatorDelegate : DiaryViewModelCoordinatorDelegate {
    var openComposeViewInvoked = false
    
    func openComposeView() {
        openComposeViewInvoked = true
    }
}
    
