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
    var bag = Set<AnyCancellable>()
    let entry0Id = UUID()
    let entry1Id = UUID()
    let entry2Id = UUID()
    let entry3Id = UUID()
    let entry4Id = UUID()
    var capturedEntries: [EntryViewModel]!
    var capturedChartViewModel: ChartViewModel!

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

        diaryViewModel = ModelBackedDiaryViewModel(model: mockGreenPandaModel,
                                        timezone: TimeZone.init(abbreviation: "CET")!,
                                        coordinatorDelegate: mockDiaryViewModelCoordinatorDelegate)
        diaryViewModel.entriesPublisher.sink(receiveValue: {
            self.capturedEntries = $0
        }).store(in: &bag)

        diaryViewModel.chartViewModelPublisher.sink(receiveValue: {
            self.capturedChartViewModel = $0
        }).store(in: &bag)
        
    }
    
    func testThatExpectedNNumberEntriesAreReturned() throws {
        XCTAssertEqual(capturedEntries?.count, 5)
    }
    
    func testThatExpectedIdsAreReturnedInOrder() throws {
        XCTAssertEqual(entry4Id, capturedEntries?[0].id)
        XCTAssertEqual(entry3Id, capturedEntries?[1].id)
        XCTAssertEqual(entry2Id, capturedEntries?[2].id)
        XCTAssertEqual(entry1Id, capturedEntries?[3].id)
        XCTAssertEqual(entry0Id, capturedEntries?[4].id)

    }
    
    func testThatExpectedEntryTextsAreReturned() throws {
        
        XCTAssertEqual(capturedEntries?[0].entryText, entry1Text)
        XCTAssertEqual(capturedEntries?[1].entryText, entry2Text)
    }
    
    func testThatExpectedEntryDatesAreReturned() throws {
        XCTAssertEqual(capturedEntries?[0].date, "Sun, 25 Oct 2020 18:01")
        XCTAssertEqual(capturedEntries?[1].date, "Mon, 21 Sep 2020 00:51")
    }
    
    func testThatExpectedScoreIsReturnedAsExpected() throws {
        XCTAssertEqual(capturedEntries?[0].score, "😁")
        XCTAssertEqual(capturedEntries?[1].score, "🙂")
        XCTAssertEqual(capturedEntries?[2].score, "😐")
        XCTAssertEqual(capturedEntries?[3].score, "😕")
        XCTAssertEqual(capturedEntries?[4].score, "😩")
    }
    
    func testThatPressingTheComposeButtonOpensTheComposeView() {
        diaryViewModel.composeButtonPressed()
        
        XCTAssertTrue(mockDiaryViewModelCoordinatorDelegate.openComposeViewInvoked)
    }
    
    func testThatUpdatesToTheModelArePickedUpAndPropagatedByTheViewModel() {
        mockGreenPandaModel.add(entry: NewDiaryEntry(id: UUID(), entryText: "abc", score: 0))
        
        XCTAssertEqual(capturedEntries.count, 6)
    }

    func testThatChartDataAreReturned() {
        XCTAssertEqual(capturedChartViewModel.chartData.count, 5)

        XCTAssertEqual(capturedChartViewModel.chartData[0].timestamp,1600642311)
        XCTAssertEqual(capturedChartViewModel.chartData[0].moodScore,1)

        XCTAssertEqual(capturedChartViewModel.chartData[4].timestamp, 1603645315)
        XCTAssertEqual(capturedChartViewModel.chartData[4].moodScore, 5)
    }

    func testThatChartDataArePublished() {
        mockGreenPandaModel.add(entry: NewDiaryEntry(id: UUID(), entryText: "abc", score: 0))

        XCTAssertEqual(capturedChartViewModel.chartData.count, 6)
    }
    
    func testThatCorrectChartRangeIsReturnedFromViewModel() {
        XCTAssertEqual(capturedChartViewModel.chartVisibleRange, Double(7*24*60*60))
    }

    func testThatCorrectXPositionIsReturnedFromViewModel() {
        mockGreenPandaModel.entriesBackingValue.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1603645315), entryText: "abc", score: 0))
        mockGreenPandaModel.entriesBackingValue.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1603645315), entryText: "abc", score: 0))
        mockGreenPandaModel.entriesBackingValue.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1603645315), entryText: "abc", score: 0))
        mockGreenPandaModel.entriesBackingValue.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1603645315), entryText: "abc", score: 0))
        mockGreenPandaModel.entriesBackingValue.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1603645315), entryText: "abc", score: 0))
        mockGreenPandaModel.entriesBackingValue.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1603645315), entryText: "abc", score: 0))
        mockGreenPandaModel.entriesBackingValue.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 2003645315), entryText: "abc", score: 0))

        XCTAssertEqual(capturedChartViewModel.chartXOffset, Double(2003040515))
    }

    func testReturnShowChartFromViewModel() {
        XCTAssertTrue(capturedChartViewModel.showChart)

        let emptyViewModel = ModelBackedDiaryViewModel(model: MockGreenPandaModel(),
                                        timezone: TimeZone.init(abbreviation: "CET")!,
                                        coordinatorDelegate: mockDiaryViewModelCoordinatorDelegate)
        _ = emptyViewModel.chartViewModelPublisher.sink{chartViewModel in
            self.capturedChartViewModel = chartViewModel
        }
        XCTAssertFalse(capturedChartViewModel.showChart)
    }

}

class MockDiaryViewModelCoordinatorDelegate : DiaryViewModelCoordinatorDelegate {
    var openComposeViewInvoked = false
    
    func openComposeView() {
        openComposeViewInvoked = true
    }
}
    
