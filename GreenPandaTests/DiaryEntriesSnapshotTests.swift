//
//  SnapshotTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 28/03/2021.
//

import XCTest
import SnapshotTesting
@testable import GreenPanda

class DiaryEntriesSnapshotTests: XCTestCase {

    let recordMode = false
    
    func testEmptyDiaryEntriesView() throws {
        let diaryEntriesViewController = DiaryViewController()
        diaryEntriesViewController.configure(with: FakeDiaryViewModel())
        assertSnapshot(matching: diaryEntriesViewController, as: .image, record: recordMode)
    }

    func testViewChangesInResponseToDataChange() throws {
        let fakeDiaryViewModel = FakeDiaryViewModel()
        let diaryEntriesViewController = DiaryViewController()
        diaryEntriesViewController.configure(with: fakeDiaryViewModel)
        assertSnapshot(matching: diaryEntriesViewController, as: .image, record: recordMode)
        fakeDiaryViewModel.setFakeEntries(fakeEntries: fakeEntries(n: 2))
        assertSnapshot(matching: diaryEntriesViewController, as: .image, record: recordMode)
    }

    func testTwoDiaryEntryView() throws {
        let fakeDiaryViewModel = FakeDiaryViewModel()
        fakeDiaryViewModel.setFakeEntries(fakeEntries: fakeEntries(n: 2))
        let diaryEntriesViewController = DiaryViewController()
        diaryEntriesViewController.configure(with: fakeDiaryViewModel)
        assertSnapshot(matching: diaryEntriesViewController, as: .image, record: recordMode)
    }

    func testEntryViewWithMultipleEntriesLessThanSeven() throws {
        let fakeDiaryViewModel = FakeDiaryViewModel()
        fakeDiaryViewModel.setFakeEntries(fakeEntries: fakeEntries(n: 4))
        let diaryEntriesViewController = DiaryViewController()
        diaryEntriesViewController.configure(with: fakeDiaryViewModel)
        assertSnapshot(matching: diaryEntriesViewController, as: .image, record: recordMode)
    }

    func testEntryViewWithMultipleEntriesMoreThanSeven() throws {
        let fakeDiaryViewModel = FakeDiaryViewModel()
        fakeDiaryViewModel.setFakeEntries(fakeEntries: fakeEntries(n: 12))
        let diaryEntriesViewController = DiaryViewController()
        diaryEntriesViewController.configure(with: fakeDiaryViewModel)
        assertSnapshot(matching: diaryEntriesViewController, as: .image, record: recordMode)
    }

    func fakeEntries(n: Int) -> [FakeEntry] {
        [Int](0..<n).map({
                            let timestamp = 1617440087 + Double($0*24*60*60)
                            return FakeEntry(id: UUID(),
                                      date: "Some date \($0)",
                                      entryText: "Some entry text \($0)",
                                      timestamp: timestamp,
                                      moodScore: Double($0),
                                      score: "🙂")})
    }

}

struct FakeEntry {
    let id: UUID
    let date: String
    let entryText: String
    let timestamp: TimeInterval
    let moodScore: Double
    let score: String
}

class FakeDiaryViewModel: DiaryViewModel {
    func chartViewDidEndPanning() {
    }
    
    func topVisibleXValueOnChartDidChange(to date: TimeInterval) {
        
    }
    
    func topVisibleRowNumberDidChange(to rowNumber: Int) {
        
    }
    
    func editEntry(at row: Int) {
        
    }
    
    func deleteEntry(at row: Int) {
        
    }

    func setFakeEntries(fakeEntries: [FakeEntry]) {
        entries = fakeEntries.map({
            EntryViewModel(id: $0.id, date: $0.date, entryText: $0.entryText, score: $0.score)
        })

        let chartData = fakeEntries.map({
            ChartDatum(timestamp: $0.timestamp, moodScore: $0.moodScore)
        })

        let showChart = !fakeEntries.isEmpty

        chartViewModel = ChartViewModel(chartData: chartData, showChart: showChart, chartXOffset: 0.0, chartVisibleRange: Double(7*24*60*60))

    }

    func composeButtonPressed() {}

    var entriesPublisher: Published<[EntryViewModel]>.Publisher {
        get { $entries }
    }

    var chartViewModelPublisher: Published<ChartViewModel>.Publisher {
        $chartViewModel
    }
    
    
    var entriesTableHiddenPublisher: Published<Bool>.Publisher {
        $entriesTableHidden
    }
    
    var promptHiddenPublisher: Published<Bool>.Publisher {
        $promptHidden
    }

    @Published private var chartViewModel: ChartViewModel = ChartViewModel(chartData: [], showChart: false)
    @Published private var entries: [EntryViewModel] = []
    @Published private var entriesTableHidden = false
    @Published private var promptHidden = false
    
    @Published var diaryOffset: Int?
    var diaryOffsetPublisher: Published<Int?>.Publisher {
        $diaryOffset
    }
}
