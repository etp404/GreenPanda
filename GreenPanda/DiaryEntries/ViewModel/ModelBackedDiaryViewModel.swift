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
            self.entries = newEntries.sorted(by: {$0.timestamp > $1.timestamp}).map { $0.toViewModel(dateFormatter: self.dateFormatter) }
            self.entriesTableHidden = newEntries.isEmpty
            self.promptHidden = !newEntries.isEmpty
            self.updateChart(entries: newEntries)
        }).store(in: &bag)
    }
    
    private func updateChart(entries: [DiaryEntry]) {
        let sortedEntries = entries.sorted(by: {$0.timestamp < $1.timestamp})
        self.chartViewModel.chartData = entries.sorted(by: {$0.timestamp < $1.timestamp}).map { $0.toChartDatum() }
        self.showChart = entries.count > 1
        updateChartOffset(sortedEntries)
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
    
    func updateChartOffset(_ entries: [DiaryEntry]) {
        if entries.count <= 1 {
            return
        }
        if entries.count == topCell.index+1 {
            chartOffset = entries[0].timestamp.timeIntervalSince1970
        } else {
            let timestampForTopVisible = entries.reversed()[topCell.index].timestamp.timeIntervalSince1970
            let timestampForSecondFromTheTop = entries.reversed()[topCell.index+1].timestamp.timeIntervalSince1970
            let timestampForTheTopmostVisiblePoint = timestampForSecondFromTheTop + Double(timestampForTopVisible - timestampForSecondFromTheTop) * (1-topCell.proportionAboveTheTopOfCollectionView)
            chartOffset = max(timestampForTheTopmostVisiblePoint - aWeekInSeconds, entries[0].timestamp.timeIntervalSince1970)
        }
    }
}

private extension DiaryEntry {
    func toViewModel(dateFormatter: DateFormatter) -> EntryViewModel {
        return EntryViewModel(id: id,
                              date: dateFormatter.string(from:timestamp),
                              entryText: entryText,
                              score: scoreSmiley(for: score))
    }
    
    func toChartDatum() -> ChartDatum {
        return ChartDatum(timestamp: timestamp.timeIntervalSince1970, moodScore: Double(score))
    }
}