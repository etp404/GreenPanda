//
//  GreenPandaTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 21/10/2020.
//

import XCTest
import Combine

@testable import GreenPanda

class ChartOffsetOnViewModelTests: XCTestCase {

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

    func testThatCorrectXPositionIsReturnedFromViewModel() {
        let date2033Jun29_08_08_35: TimeInterval = 2003645315
        let date2033Jun22_08_08_35: TimeInterval = 2003040515

        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: date2020Oct25_17_01_55), entryText: "abc", score: 0))
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: date2020Oct25_17_01_55), entryText: "abc", score: 0))
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: date2020Oct25_17_01_55), entryText: "abc", score: 0))
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: date2020Oct25_17_01_55), entryText: "abc", score: 0))
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: date2020Oct25_17_01_55), entryText: "abc", score: 0))
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: date2020Oct25_17_01_55), entryText: "abc", score: 0))
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: date2033Jun29_08_08_35), entryText: "abc", score: 0))

        XCTAssertEqual(capturedChartViewModel.chartXOffset, Double(date2033Jun22_08_08_35))
    }


    func testThatChartXOffsetIsSetWhenUserScrolls() {
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: date2020Oct25_17_01_55), entryText: "abc", score: 0))
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: date2033Jun29_08_08_35), entryText: "abc", score: 0))
        
        diaryViewModel.proportionOfCellAboveTopOfCollectionView(0.4, index: 2)
        XCTAssertEqual(capturedChartViewModel.chartXOffset, Double(1602444114.6 - 7*24*60*60))
    }
    
    func testThatCorrectChartXOffsetIsSetWhenUserScrollsToTheLastEntry() {
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: date2020Oct25_17_01_55), entryText: "abc", score: 0))
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: date2033Jun29_08_08_35), entryText: "abc", score: 0))
        
        diaryViewModel.proportionOfCellAboveTopOfCollectionView(0.4, index: 6)
        XCTAssertEqual(capturedChartViewModel.chartXOffset, Double(date2020Sep20_23_51_51))
    }
    
    func testThatOffsetDoesntGoFurtherThanLastTimestamp() {
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: date2020Oct25_17_01_55), entryText: "abc", score: 0))
        mockGreenPandaModel.entries.append(DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: date2033Jun29_08_08_35), entryText: "abc", score: 0))
        
        diaryViewModel.proportionOfCellAboveTopOfCollectionView(0, index: 4)
        XCTAssertEqual(capturedChartViewModel.chartXOffset, Double(date2020Sep20_23_51_51))
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
    
