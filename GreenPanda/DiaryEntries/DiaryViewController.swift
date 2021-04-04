//
//  DiaryViewController.swift
//  GreenPanda
//
//  Created by Matthew Mould on 24/10/2020.
//

import UIKit
import Combine
import Charts

class DiaryViewController: ViewController {

    @IBOutlet weak var chart: LineChartView!
    private var bag = Set<AnyCancellable>()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func composeButtonPRessed(_ sender: Any) {
        viewModel?.composeButtonPressed()
    }
    
    private var viewModel:DiaryViewModel?
    private var dataSource:UICollectionViewDiffableDataSource<Int, EntryViewModel>?
    func configure(with viewModel: DiaryViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "DiaryEntryCell", bundle: nil),
                                forCellWithReuseIdentifier: DiaryEntryCell.reuseIdentifier)
        
        dataSource = UICollectionViewDiffableDataSource<Int, EntryViewModel>(collectionView: collectionView) { collectionView, indexPath, item in
            let diaryEntry = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryEntryCell.reuseIdentifier, for: indexPath) as! DiaryEntryCell
            diaryEntry.bodyText.text = item.entryText
            diaryEntry.date.text = item.date
            diaryEntry.score.text = item.score

            return diaryEntry
        }
        
        collectionView.dataSource = dataSource
        viewModel?.entriesPublisher.sink{entries in
            self.applySnapshot(entries:entries)
        }.store(in: &bag)
        
        if let viewModel = viewModel, viewModel.showChart {
            setUpChart()
        }
        
        viewModel?.chartDataPublisher.sink{entries in
            if let viewModel = self.viewModel, viewModel.showChart {
                self.updateChart(viewModel)
            }
        }.store(in: &bag)
    }
    
    func applySnapshot(entries:[EntryViewModel]?, animatingDifferences: Bool = true) {
        guard let entries = entries, let dataSource = dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, EntryViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(entries)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func setUpChart() {
        guard let viewModel = viewModel else { return }
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.xAxis.valueFormatter = DateValueFormatter()
        chart.xAxis.labelRotationAngle = -45
        
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.legend.enabled = false
        
        updateChart(viewModel)
    }

    private func updateChart(_ viewModel: DiaryViewModel) {
        let dataset = LineChartDataSet(entries: viewModel.chartData.map{
            ChartDataEntry(x: $0.timestamp, y: $0.moodScore)
        })
        dataset.drawFilledEnabled = true
        dataset.drawCirclesEnabled = true
        dataset.mode = .cubicBezier
        let data = LineChartData(dataSet: dataset)
        data.setDrawValues(false)
        self.chart.data = data
        
        chart.setVisibleXRangeMaximum(viewModel.chartVisibleRange)
        chart.resetViewPortOffsets()
        chart.moveViewToX(viewModel.chartXOffset)
    }

}

private class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()

    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM"
    }

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
