//
//  DiaryViewModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 23/10/2020.
//

import Foundation
import Combine

struct EntryViewModel: Hashable {
    let id: UUID
    let date: String
    let entryText: String
    let score: String
}

struct ChartDatum {
    let timestamp: TimeInterval
    let moodScore: Double
}

struct ChartViewModel {
    var chartData: [ChartDatum]
    var showChart: Bool
    var chartXOffset: Double = 0
    var chartVisibleRange: Double = Double(7*24*60*60)
}

protocol DiaryViewModel {
    func composeButtonPressed()
    var chartViewModelPublisher: Published<ChartViewModel>.Publisher { get }
    var entriesPublisher: Published<[EntryViewModel] >.Publisher { get }
    var entriesTableHiddenPublisher: Published<Bool>.Publisher { get }
    var promptHiddenPublisher: Published<Bool>.Publisher { get }
    func proportionOfCellAboveTopOfCollectionView(_ proportion: Double, index: Int)
    func topVisibleRowNumberDidChange(to rowNumber: Int)
    func deleteEntry(at row:Int)
    func editEntry(at row: Int)
}

class ModelBackedDiaryViewModel: NSObject, DiaryViewModel {
    private let greenPandaModel: GreenPandaModel
    private let timezone: TimeZone
    private let coordinatorDelegate: DiaryViewModelCoordinatorDelegate
    private var cancellable: AnyCancellable? = nil
    private let aWeekInSeconds: TimeInterval = 7*24*60*60
    private var bag = Set<AnyCancellable>()
    private var topCell = TopCell(index: 0, proportionAboveTheTopOfCollectionView: 0) {
        didSet {
            updateChart(entries: greenPandaModel.entries)
        }
    }
    @Published private var topVisibleRowNumber:Int? = nil
    
    init(model greenPandaModel: GreenPandaModel,
         timezone: TimeZone,
         coordinatorDelegate: DiaryViewModelCoordinatorDelegate) {
        self.greenPandaModel = greenPandaModel
        self.timezone = timezone
        self.coordinatorDelegate = coordinatorDelegate
        chartViewModel = ChartViewModel(chartData: [], showChart: false)

        super.init()
        
        cancellable = greenPandaModel.entriesPublisher.sink(receiveValue: { (newEntries:[DiaryEntry]) in
            self.entries = newEntries.sorted(by: {$0.timestamp > $1.timestamp}).map { self.convertToViewModel(entry: $0) }
            self.entriesTableHidden = newEntries.isEmpty
            self.promptHidden = !newEntries.isEmpty
            self.updateChart(entries: newEntries)
        })
        
        $newValueForDiaryOffset.removeDuplicates().compactMap{$0}.sink(receiveValue: { (diaryOffset: Int) in
            self.diaryOffset = diaryOffset
        }).store(in: &bag)
    }
    
    private func updateChart(entries: [DiaryEntry]) {
        let sortedEntries = entries.sorted(by: {$0.timestamp < $1.timestamp})
        self.chartData = sortedEntries.map { self.convertToChartDatum(entry: $0) }
        self.chartViewModel.chartData = entries.sorted(by: {$0.timestamp < $1.timestamp}).map { self.convertToChartDatum(entry: $0) }
        self.chartViewModel.chartData = entries.sorted(by: {$0.timestamp < $1.timestamp}).map { self.convertToChartDatum(entry: $0) }
        self.chartViewModel.showChart = entries.count > 1
        if entries.count > 1 {
            self.chartViewModel.chartXOffset = calculateChartOffset(sortedEntries)
        }
    }
    
    @Published var entries: [EntryViewModel] = []
    var entriesPublisher: Published<[EntryViewModel]>.Publisher { $entries }

    @Published var chartViewModel: ChartViewModel
    var chartViewModelPublisher: Published<ChartViewModel>.Publisher { $chartViewModel }

    @Published var chartData: [ChartDatum] = []
    var chartDataPublisher: Published<[ChartDatum]>.Publisher {
        $chartData
    }
    
    @Published var entriesTableHidden: Bool = true
    var entriesTableHiddenPublisher: Published<Bool>.Publisher {
        $entriesTableHidden
    }

    @Published var promptHidden = false
    var promptHiddenPublisher: Published<Bool>.Publisher {
        $promptHidden
    }
    
    @Published private var newValueForDiaryOffset: Int?
    
    @Published var diaryOffset: Int?
    
    var diaryOffsetPublisher: Published<Int?>.Publisher {
        $diaryOffset
    }

    let chartVisibleRange = Double(7*24*60*60)
    
    var showChart: Bool {
        get {
            !self.entries.isEmpty
        }
    }
    
    func composeButtonPressed() {
        coordinatorDelegate.openComposeView()
    }
    
    func deleteEntry(at row:Int) {
        greenPandaModel.deleteEntry(with: entries[row].id)
    }
    
    func editEntry(at row: Int) {
        coordinatorDelegate.openEditView(diaryEntry: entries[row])
    }
    
    func topVisibleRowNumberDidChange(to rowNumber: Int) {
        topVisibleRowNumber = rowNumber
    }
    
    func proportionOfCellAboveTopOfCollectionView(_ proportion: Double, index: Int) {
       topCell = TopCell(index: index, proportionAboveTheTopOfCollectionView: proportion)
    }
    
    func calculateChartOffset(_ entries: [DiaryEntry]) -> Double {
        if entries.count == topCell.index+1 {
            return entries[0].timestamp.timeIntervalSince1970
        }
        let timestampForTopVisible = entries.reversed()[topCell.index].timestamp.timeIntervalSince1970
        let timestampForItemBelow = entries.reversed()[topCell.index+1].timestamp.timeIntervalSince1970
        let timstampThatWantsToBeVisible = timestampForItemBelow + Double(timestampForTopVisible - timestampForItemBelow) * (1-topCell.proportionAboveTheTopOfCollectionView)
        let potentialTimestamp = timstampThatWantsToBeVisible - aWeekInSeconds
        if potentialTimestamp <= entries[0].timestamp.timeIntervalSince1970 {
            return entries[0].timestamp.timeIntervalSince1970
        }
        return potentialTimestamp
    }
    
    private func scoreSmiley(for score:Int) -> String {
        switch (score) {
        case 0: return "😩"
        case 1: return "😕"
        case 2: return "😐"
        case 3: return "🙂"
        case 4: return "😁"
        default: return ""
        }
    }
    
    private func convertToViewModel(entry: DiaryEntry) -> EntryViewModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm"
        dateFormatter.timeZone = timezone
        return EntryViewModel(id: entry.id,
                              date: dateFormatter.string(from:entry.timestamp),
                              entryText: entry.entryText,
                              score: scoreSmiley(for: entry.score))
    }

    private func convertToChartDatum(entry: DiaryEntry) -> ChartDatum {
        return ChartDatum(timestamp: entry.timestamp.timeIntervalSince1970, moodScore: Double(entry.score))
    }
    
    struct TopCell {
        let index: Int
        let proportionAboveTheTopOfCollectionView: Double
    }

}
