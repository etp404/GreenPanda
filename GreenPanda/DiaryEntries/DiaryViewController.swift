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

    @IBOutlet weak var composeButton: UIButton!
    @IBOutlet weak var promtMessage: UILabel!
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func composeButtonPressed(_ sender: Any) {
        viewModel?.composeButtonPressed()
    }
    
    private var bag = Set<AnyCancellable>()
    private var viewModel:DiaryViewModel?
    private var dataSource:UICollectionViewDiffableDataSource<Int, EntryViewModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24,
                                                      weight: .regular,
                                                      scale: .large)

        let pencilButton = UIImage(systemName: "square.and.pencil", withConfiguration: largeConfig)
        composeButton.setImage(pencilButton, for: .normal)
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            return UISwipeActionsConfiguration(actions: [{
                let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {[weak self] _, _, completion in
                    self?.deleteAt(indexPath: indexPath)
                    completion(true)
                })
                deleteAction.image = UIImage(systemName: "trash")
                return deleteAction
            }()
            ])
        }
        
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

        viewModel?.entriesTableHiddenPublisher.sink{hideTable in
            self.collectionView.isHidden = hideTable
        }.store(in: &bag)
        
        viewModel?.showChartPublisher.sink{showChart in
            self.chart.isHidden = !showChart
        }.store(in: &bag)
        
        viewModel?.promptHiddenPublisher.sink{promptHidden in
            self.promtMessage.isHidden = promptHidden
        }.store(in: &bag)
        
        setUpChart()
        viewModel?.chartViewModelPublisher.sink{chartViewModel in
            self.updateChart(chartViewModel)
        }.store(in: &bag)
        
        viewModel?.chartOffsetPublisher.sink{chartOffset in
            self.chart.moveViewToX(chartOffset)
        }.store(in: &bag)
        
        collectionView.delegate = self
    }
    
    func configure(with viewModel: DiaryViewModel) {
        self.viewModel = viewModel
    }
    
    func applySnapshot(entries:[EntryViewModel]?, animatingDifferences: Bool = true) {
        guard let entries = entries, let dataSource = dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, EntryViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(entries)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func setUpChart() {
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.xAxis.valueFormatter = DateValueFormatter()
        chart.xAxis.labelRotationAngle = -45
        
        chart.leftAxis.axisMinimum = 0.0
        chart.leftAxis.axisMaximum = 4.0
        
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.legend.enabled = false
        
        chart.doubleTapToZoomEnabled = false
        chart.pinchZoomEnabled = false
        chart.scaleYEnabled = false
        chart.scaleXEnabled = true
        chart.highlightPerTapEnabled = false
        chart.highlightPerDragEnabled = false
        chart.dragEnabled = false
    }

    private func deleteAt(indexPath: IndexPath) {
        viewModel?.deleteEntry(at: indexPath.row)
    }
    
    private func editEntry(at indexPath: IndexPath) {
        viewModel?.editEntry(at: indexPath.row)
    }
    
    private func updateChart(_ chartViewModel: ChartViewModel) {
        if let viewModel = viewModel,
           !viewModel.showChart {
            chart.isHidden = true
            return
        }
        let dataset = LineChartDataSet(entries: chartViewModel.chartData.map{
            ChartDataEntry(x: $0.timestamp, y: $0.moodScore)
        })
        dataset.drawFilledEnabled = true
        dataset.drawCirclesEnabled = true
        dataset.mode = .horizontalBezier
        let data = LineChartData(dataSet: dataset)
        data.setDrawValues(false)
        self.chart.data = data
        
        chart.setVisibleXRangeMaximum(chartViewModel.chartVisibleRange)
        chart.resetViewPortOffsets()
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

extension DiaryViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let topRow = collectionView.indexPathForItem(at:  scrollView.contentOffset),
           let topCell = collectionView.cellForItem(at: topRow) {
            let topCellTopInView = collectionView.convert(topCell.frame, to:view).origin.y
            let collectionViewTopInView = collectionView.superview!.convert(collectionView.frame, to:view).origin.y
            let positionOfTopCutOffInCell = collectionViewTopInView - topCellTopInView
            let positionOfTopCutOffAsProportionOfCell = positionOfTopCutOffInCell/topCell.frame.size.height
            viewModel?.proportionOfCellAboveTopOfCollectionView(positionOfTopCutOffAsProportionOfCell,
                                                                index: topRow.row)
        }
    }
}
