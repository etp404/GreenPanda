//
//  DiaryViewController.swift
//  GreenPanda
//
//  Created by Matthew Mould on 24/10/2020.
//

import UIKit
import Combine
class DiaryViewController: ViewController {

    private var someCancellable: AnyCancellable?
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
        someCancellable = viewModel?.$entries.sink{entries in
            self.applySnapshot(entries:entries)
        }

    }
    
    func applySnapshot(entries:[EntryViewModel]?, animatingDifferences: Bool = true) {
        guard let entries = entries, let dataSource = dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, EntryViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(entries)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

}
