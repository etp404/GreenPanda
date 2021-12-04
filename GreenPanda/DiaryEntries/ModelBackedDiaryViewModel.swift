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
    var chartXOffset: Double = 0.0
    var chartVisibleRange: Double = Double(7*24*60*60)
}

protocol DiaryViewModel {
    func composeButtonPressed()
    var chartViewModelPublisher: Published<ChartViewModel>.Publisher { get }
    var entriesPublisher: Published<[EntryViewModel] >.Publisher { get }
    func deleteEntry(at row:Int)
}

class ModelBackedDiaryViewModel: NSObject, DiaryViewModel {
    private let greenPandaModel: GreenPandaModel
    private let timezone: TimeZone
    private let coordinatorDelegate: DiaryViewModelCoordinatorDelegate
    private var cancellable: AnyCancellable? = nil
    
    init(model greenPandaModel: GreenPandaModel,
         timezone: TimeZone,
         coordinatorDelegate: DiaryViewModelCoordinatorDelegate) {
        self.greenPandaModel = greenPandaModel
        self.timezone = timezone
        self.coordinatorDelegate = coordinatorDelegate
        chartViewModel = ChartViewModel(chartData: [], showChart: false)

        super.init()
        
        cancellable = greenPandaModel.entries.sink(receiveValue: { (newEntries:[DiaryEntry]) in
            self.entries = newEntries.sorted(by: {$0.timestamp > $1.timestamp}).map { self.convertToViewModel(entry: $0) }
            self.chartData = newEntries.sorted(by: {$0.timestamp < $1.timestamp}).map { self.convertToChartDatum(entry: $0) }
            self.chartViewModel.chartData = newEntries.sorted(by: {$0.timestamp < $1.timestamp}).map { self.convertToChartDatum(entry: $0) }
            self.chartViewModel.chartData = newEntries.sorted(by: {$0.timestamp < $1.timestamp}).map { self.convertToChartDatum(entry: $0) }
            self.chartViewModel.showChart = newEntries.count > 1

            if let lastDatapoint = self.chartData.last {
                self.chartViewModel.chartXOffset = Double(lastDatapoint.timestamp - 7*24*60*60)
            }
        } )

    }
    
    @Published var entries: [EntryViewModel] = []
    var entriesPublisher: Published<[EntryViewModel]>.Publisher { $entries }

    @Published var chartViewModel: ChartViewModel
    var chartViewModelPublisher: Published<ChartViewModel>.Publisher { $chartViewModel }

    @Published var chartData: [ChartDatum] = []
    var chartDataPublisher: Published<[ChartDatum]>.Publisher {
        $chartData
    }


    let chartVisibleRange = Double(7*24*60*60)
    var chartXOffset: Double {
        get {
            guard let lastDatapoint = chartData.last else {return 0.0}
            return Double(lastDatapoint.timestamp - 7*24*60*60)
        }
    }

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
    
    private func scoreSmiley(for score:Int) -> String {
        switch (score) {
        case 1: return "😩"
        case 2: return "😕"
        case 3: return "😐"
        case 4: return "🙂"
        case 5: return "😁"
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

}
