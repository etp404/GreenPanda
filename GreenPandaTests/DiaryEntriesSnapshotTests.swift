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
        let fakeEntries = [FakeEntry(id: UUID(),
                                     date: "some date as string 1",
                                     entryText: "Some entry text 1",
                                     timestamp: Date().timeIntervalSince1970,
                                     moodScore: 4,
                                     score: "🙂"),
                           FakeEntry(id: UUID(),
                                     date: "some date as string 2",
                                     entryText: "Some entry text 2",
                                     timestamp: Date().timeIntervalSince1970 + 24*60*60,
                                     moodScore: 4,
                                     score: "🙁"),
                           FakeEntry(id: UUID(),
                                     date: "some date as string 3",
                                     entryText: "Some entry text 3",
                                     timestamp: Date().timeIntervalSince1970 + 2*24*60*60,
                                     moodScore: 4,
                                     score: "🙂"),
                           FakeEntry(id: UUID(),
                                     date: "some date as string 4",
                                     entryText: "Some entry text 4",
                                     timestamp: Date().timeIntervalSince1970 + 3*24*60*60,
                                     moodScore: 4,
                                     score: "🥪"),
                           FakeEntry(id: UUID(),
                                     date: "some date as string 5",
                                     entryText: "Some entry text 5",
                                     timestamp: Date().timeIntervalSince1970 + 4*24*60*60,
                                     moodScore: 4,
                                     score: "🙂")]
        let fakeDiaryViewModel = FakeDiaryViewModel()
        fakeDiaryViewModel.setFakeEntries(fakeEntries: fakeEntries)
        let diaryEntriesViewController = DiaryViewController()
        diaryEntriesViewController.configure(with: fakeDiaryViewModel)
        assertSnapshot(matching: diaryEntriesViewController, as: .image)
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

class FakeDiaryViewModel: DiaryViewModelInterface {
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
