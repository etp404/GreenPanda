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

    private var someCancellable: AnyCancellable?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chart: LineChartView!
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
        someCancellable = viewModel?.$entries.sink{entries in
            self.applySnapshot(entries:entries)
        }
        
        doGraph()

    }
    
    func applySnapshot(entries:[EntryViewModel]?, animatingDifferences: Bool = true) {
        guard let entries = entries, let dataSource = dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, EntryViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(entries)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func doGraph() {
//        let ys1 = [0.0, 5.0, 3.0, 2.0, 5.0, 5.0, 3.0, 2.0, 1.0]
//
//        let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: x, y: y) }
        
        let now = Date()
        let yse1 = Array(0...100).reversed().map({(index: Int) -> ChartDataEntry in
            let x = now.timeIntervalSince1970 - Double(index*24*60*60)
            return ChartDataEntry(x:x , y: Double(Array(1...5).randomElement()!))
        })
        
        let data = LineChartData()
        let ds1 = LineChartDataSet(entries: yse1)
        ds1.drawFilledEnabled = true
        ds1.drawCirclesEnabled = true
        ds1.mode = .cubicBezier
        data.append(ds1)
        data.setDrawValues(false)

        self.chart.data = data
        
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.legend.enabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.xAxis.valueFormatter = DateValueFormatter()
        chart.xAxis.labelRotationAngle = -45
        chart.setVisibleXRange(minXRange: 7*24*60*60, maxXRange: 7*24*60)
        chart.resetViewPortOffsets()
        chart.moveViewToX(now.timeIntervalSince1970 + 93*24*60*60)


    }
}

public class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

