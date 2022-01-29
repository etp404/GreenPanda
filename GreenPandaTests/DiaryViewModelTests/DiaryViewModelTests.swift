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

    let date2020Sep20_22_51_53: TimeInterval = 1600642313
    let date2020Oct25_17_01_55: TimeInterval = 1603645315
    let date2020Sep20_22_51_52: TimeInterval = 1600642312
    let date2020Sep20_22_51_54: TimeInterval = 1600642314
    let date2020Sep20_23_51_51: TimeInterval = 1600642311
    let date2033Jun29_08_08_35: TimeInterval = 2003645315

    let entry1Text = "entry1Text"
    let entry2Text = "entry2Text"
    var mockGreenPandaModel: MockGreenPandaModel!
    var diaryViewModel: DiaryViewModel!
    private var mockDiaryViewModelCoordinatorDelegate: MockDiaryViewModelCoordinatorDelegate!
    var bag = Set<AnyCancellable>()
    let entry0Id = UUID()
    let entry1Id = UUID()
    let entry2Id = UUID()
    let entry3Id = UUID()
    let entry4Id = UUID()
    var capturedEntries: [EntryViewModel]!
    var capturedChartViewModel: ChartViewModel!
    var capturedShowChart: Bool!
    var diaryEntry2:DiaryEntry!

    override func setUp() {
        self.continueAfterFailure = false;
        mockGreenPandaModel = MockGreenPandaModel()
        diaryEntry2 = DiaryEntry(id: entry2Id, timestamp: Date(timeIntervalSince1970: date2020Sep20_22_51_53), entryText: entry2Text, score: 2)
        mockGreenPandaModel.entries = [
            DiaryEntry(id: entry4Id, timestamp: Date(timeIntervalSince1970: date2020Oct25_17_01_55), entryText: entry1Text, score: 4),
            diaryEntry2,
            DiaryEntry(id: entry1Id, timestamp: Date(timeIntervalSince1970: date2020Sep20_22_51_52), entryText: entry2Text, score: 1),
            DiaryEntry(id: entry3Id, timestamp: Date(timeIntervalSince1970: date2020Sep20_22_51_54), entryText: entry2Text, score: 3),
            DiaryEntry(id: entry0Id, timestamp: Date(timeIntervalSince1970: date2020Sep20_23_51_51), entryText: entry2Text, score: 0)]
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
        XCTAssertEqual(capturedChartViewModel.chartData[0].moodScore, 0)

        XCTAssertEqual(capturedChartViewModel.chartData[4].timestamp, date2020Oct25_17_01_55)
        XCTAssertEqual(capturedChartViewModel.chartData[4].moodScore, 4)
    }

    func testThatChartDataArePublished() {
        mockGreenPandaModel.add(entry: NewDiaryEntry(id: UUID(), entryText: "abc", score: 0))

        XCTAssertEqual(capturedChartViewModel.chartData.count, 6)
    }
    
    func testThatCorrectChartRangeIsReturnedFromViewModel() {
        XCTAssertEqual(capturedChartViewModel.chartVisibleRange, Double(7*24*60*60))
    }

    func testReturnShowChartFromViewModel() {
        let mockGreenPandaModel = MockGreenPandaModel()

        let someViewModel = ModelBackedDiaryViewModel(model: mockGreenPandaModel,
                                        timezone: TimeZone.init(abbreviation: "CET")!,
                                        coordinatorDelegate: mockDiaryViewModelCoordinatorDelegate)
        someViewModel.showChartPublisher.sink{showChart in
            self.capturedShowChart = showChart
        }.store(in: &bag)
        XCTAssertFalse(capturedShowChart)
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 2003645315), entryText: "abc", score: 0))
        XCTAssertFalse(capturedShowChart)
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 2003645315), entryText: "abc", score: 0))
        XCTAssertTrue(capturedShowChart)
    }
    
    func testThatDeletionByIdIsPassedToCore() throws {
        diaryViewModel.deleteEntry(at: 2)
        let capturedIdToDelete = try XCTUnwrap(mockGreenPandaModel.capturedIdToDelete)
        XCTAssertEqual(capturedIdToDelete, entry2Id)
    }
    
    func testThatCorrectEntryIsPassedToEditCall() throws {
        diaryViewModel.editEntry(at: 2)
        let diaryEntryBeingEdited = try XCTUnwrap(mockDiaryViewModelCoordinatorDelegate.diaryEntryBeingEdited)
        XCTAssertEqual(diaryEntryBeingEdited.id, entry2Id)
    }

    func testThatCollectionViewIsHiddenWhenThereAreNoEntries() throws {
        var capturedEntriesTableHidden = false
        diaryViewModel.entriesTableHiddenPublisher.sink{entriesTableHidden in
            capturedEntriesTableHidden = entriesTableHidden
        }.store(in: &bag)
        mockGreenPandaModel.entries = []

        XCTAssertTrue(capturedEntriesTableHidden)
    }
    
    func testThatCollectionViewIsVisibleWhenThereAreEntries() throws {
        var capturedEntriesTableHidden = false
        diaryViewModel.entriesTableHiddenPublisher.sink{entriesTableHidden in
            capturedEntriesTableHidden = entriesTableHidden
        }.store(in: &bag)

        XCTAssertFalse(capturedEntriesTableHidden)
    }
    
    func testThatPromptIsShownNoEntries() throws {
        var capturedPromptHidden = false
        diaryViewModel.promptHiddenPublisher.sink{promptHidden in
            capturedPromptHidden = promptHidden
        }.store(in: &bag)
        mockGreenPandaModel.entries = []

        XCTAssertFalse(capturedPromptHidden)
    }
    
    func testThatPromptIsNotShownWhenThereAreEntries() throws {
        var capturedPromptHidden = false
        diaryViewModel.promptHiddenPublisher.sink{promptHidden in
            capturedPromptHidden = promptHidden
        }.store(in: &bag)

        XCTAssertTrue(capturedPromptHidden)
    }
        
}

private class MockDiaryViewModelCoordinatorDelegate : DiaryViewModelCoordinatorDelegate {
    var diaryEntryBeingEdited: EntryViewModel?
    
    func openEditView(diaryEntry: EntryViewModel) {
        diaryEntryBeingEdited = diaryEntry
    }
    
    var openComposeViewInvoked = false
    
    func openComposeView() {
        openComposeViewInvoked = true
    }
}
    
