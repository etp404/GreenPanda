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

    func testEmptyDiaryEntriesView() throws {
        let diaryEntriesViewController = DiaryViewController()
        diaryEntriesViewController.configure(with: FakeDiaryViewModel())
        assertSnapshot(matching: diaryEntriesViewController, as: .image)
    }

    func testOneDiaryEntryView() throws {
        let fakeDiaryViewModel = FakeDiaryViewModel()
        fakeDiaryViewModel.setFakeEntries(fakeEntries: [FakeEntry(id: UUID(), date: "some date as string", entryText: "Some entry text", timestamp: Date().timeIntervalSince1970, moodScore: 4, score: "🙂")])
        let diaryEntriesViewController = DiaryViewController()
        diaryEntriesViewController.configure(with: fakeDiaryViewModel)
        assertSnapshot(matching: diaryEntriesViewController, as: .image)
    }

    func testEntryViewWithMultipleEntriesLessThanSeven() throws {
        let fakeDiaryViewModel = FakeDiaryViewModel()
        fakeDiaryViewModel.setFakeEntries(fakeEntries: fakeEntries(n: 4))
        let diaryEntriesViewController = DiaryViewController()
        diaryEntriesViewController.configure(with: fakeDiaryViewModel)
        assertSnapshot(matching: diaryEntriesViewController, as: .image)
    }

    func testEntryViewWithMultipleEntriesMoreThanSeven() throws {
        let fakeDiaryViewModel = FakeDiaryViewModel()
        fakeDiaryViewModel.setFakeEntries(fakeEntries: fakeEntries(n: 12))
        let diaryEntriesViewController = DiaryViewController()
        diaryEntriesViewController.configure(with: fakeDiaryViewModel)
        assertSnapshot(matching: diaryEntriesViewController, as: .image)
    }

    func fakeEntries(n: Int) -> [FakeEntry] {
        [Int](0...n).map({
                            FakeEntry(id: UUID(),
                                      date: "some date as string \($0)",
                                      entryText: "Some entry text \($0)",
                                      timestamp: Date().timeIntervalSince1970 + Double($0*24*60*60),
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
    }

    func composeButtonPressed() {}
    
    var chartData: [ChartDatum] = [ChartDatum]()
    
    var showChart: Bool = false
    
    var chartXOffset: Double = 0.0
    
    var chartVisibleRange: Double = 0.0
    
    var entriesPublisher: Published<[EntryViewModel]>.Publisher {
        get { $entries }
    }
    
    @Published var entries: [EntryViewModel] = []
    
    
}
