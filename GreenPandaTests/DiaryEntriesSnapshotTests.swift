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
        assertSnapshot(matching: diaryEntriesViewController, as: .image)
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
        assertSnapshot(matching: diaryEntriesViewController, as: .image, record: false)
    }

    func fakeEntries(n: Int) -> [FakeEntry] {
        [Int](0...n).map({
                            FakeEntry(id: UUID(),
                                      date: "some date as string \($0)",
                                      entryText: "Some entry text \($0)",
                                      timestamp: 1617440087 + Double($0*24*60*60),
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
