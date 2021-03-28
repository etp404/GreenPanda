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
        
    }

}

class FakeDiaryViewModel: DiaryViewModelInterface {
    func composeButtonPressed() {}
    
    var chartData: [ChartDatum] = [ChartDatum]()
    
    var showChart: Bool = false
    
    var chartXOffset: Double = 0.0
    
    var chartVisibleRange: Double = 0.0
    
    var entriesPublisher: Published<[EntryViewModel]>.Publisher {
        get { $entries }
    }
    
    @Published private var entries: [EntryViewModel] = []
    
    
}
