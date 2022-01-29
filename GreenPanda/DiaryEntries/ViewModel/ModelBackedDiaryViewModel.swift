//
//  DiaryViewModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 23/10/2020.
//

import Foundation
import Combine

struct ChartViewModel {
    var chartData: [ChartDatum]
    var chartVisibleRange: Double = Double(7*24*60*60)
}

class ModelBackedDiaryViewModel: NSObject, DiaryViewModel {    
    private let dateFormatter: DateFormatter
    private let greenPandaModel: GreenPandaModel
    private let coordinatorDelegate: DiaryViewModelCoordinatorDelegate
    private let aWeekInSeconds: TimeInterval = 7*24*60*60
    private var bag = Set<AnyCancellable>()
    private var topCell = TopCell(index: 0, proportionAboveTheTopOfCollectionView: 0) {
        didSet {
            updateChart(entries: greenPandaModel.entries)
        }
    }

    @Published private var chartOffset: Double = 0.0
    var chartOffsetPublisher: Published<Double>.Publisher { $chartOffset }

    @Published private var entries: [EntryViewModel] = []
    var entriesPublisher: Published<[EntryViewModel]>.Publisher { $entries }

    @Published private var chartViewModel: ChartViewModel
    var chartViewModelPublisher: Published<ChartViewModel>.Publisher { $chartViewModel }

    @Published private var chartData: [ChartDatum] = []
    var chartDataPublisher: Published<[ChartDatum]>.Publisher {
        $chartData
    }
    
    @Published private var entriesTableHidden: Bool = true
    var entriesTableHiddenPublisher: Published<Bool>.Publisher {
        $entriesTableHidden
    }

    @Published private var promptHidden = false
    var promptHiddenPublisher: Published<Bool>.Publisher {
        $promptHidden
    }
    
    @Published var showChart = false
    var showChartPublisher: Published<Bool>.Publisher {
        $showChart
    }
    
    init(model greenPandaModel: GreenPandaModel,
         timezone: TimeZone,
         coordinatorDelegate: DiaryViewModelCoordinatorDelegate) {
        self.greenPandaModel = greenPandaModel
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm"
        dateFormatter.timeZone = timezone
        
        self.coordinatorDelegate = coordinatorDelegate
        chartViewModel = ChartViewModel(chartData: [])

        super.init()
        
        greenPandaModel.entriesPublisher.sink(receiveValue: { (newEntries:[DiaryEntry]) in
            self.entries = newEntries.sorted(by: {$0.timestamp > $1.timestamp}).map { self.convertToViewModel(entry: $0) }
            self.entriesTableHidden = newEntries.isEmpty
            self.promptHidden = !newEntries.isEmpty
            self.updateChart(entries: newEntries)
        }).store(in: &bag)
    }
    
    private func updateChart(entries: [DiaryEntry]) {
        let sortedEntries = entries.sorted(by: {$0.timestamp < $1.timestamp})
        self.chartData = sortedEntries.map { self.convertToChartDatum(entry: $0) }
        self.chartViewModel.chartData = entries.sorted(by: {$0.timestamp < $1.timestamp}).map { self.convertToChartDatum(entry: $0) }
        self.showChart = entries.count > 1
        if entries.count > 1 {
            self.chartOffset = calculateChartOffset(sortedEntries)
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
    
    private func convertToViewModel(entry: DiaryEntry) -> EntryViewModel {
        return EntryViewModel(id: entry.id,
                              date: dateFormatter.string(from:entry.timestamp),
                              entryText: entry.entryText,
                              score: scoreSmiley(for: entry.score))
    }

    private func convertToChartDatum(entry: DiaryEntry) -> ChartDatum {
        return ChartDatum(timestamp: entry.timestamp.timeIntervalSince1970, moodScore: Double(entry.score))
    }
}
