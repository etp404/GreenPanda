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

    func testOneDiaryEntryView() throws {
        let fakeDiaryViewModel = FakeDiaryViewModel()
        fakeDiaryViewModel.setFakeEntries(fakeEntries: fakeEntries(n: 1))
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
        [Int](0...n).map({
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

    @Published var chartViewModel: ChartViewModel = ChartViewModel(chartData: [], showChart: false)

    var chartViewModelPublisher: Published<ChartViewModel>.Publisher {
        $chartViewModel
    }
    
    func setFakeEntries(fakeEntries: [FakeEntry]) {
        chartData = fakeEntries.map({
            ChartDatum(timestamp: $0.timestamp, moodScore: $0.moodScore)
        })
        entries = fakeEntries.map({
            EntryViewModel(id: $0.id, date: $0.date, entryText: $0.entryText, score: $0.score)
        })
        if !fakeEntries.isEmpty {
            showChart = true
        }
    }

    func composeButtonPressed() {}
    
    
    var chartDataPublisher: Published<[ChartDatum]>.Publisher {
        $chartData
    }

    @Published var chartData: [ChartDatum] = [ChartDatum]()
    
    var showChart: Bool = false
    
    var chartXOffset: Double = 0.0
    
    let chartVisibleRange = Double(7*24*60*60)
    
    var entriesPublisher: Published<[EntryViewModel]>.Publisher {
        get { $entries }
    }
    
    @Published var entries: [EntryViewModel] = []
    
    
}
