//
//  DiaryViewController.swift
//  GreenPanda
//
//  Created by Matthew Mould on 24/10/2020.
//

import UIKit

class DiaryViewController: ViewController {

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
        applySnapshot()

    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        guard let entries = viewModel?.entries, let dataSource = dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, EntryViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(entries)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

}

extension DiaryViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel?.numberOfEntries ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let diaryEntry = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryEntryCell.reuseIdentifier, for: indexPath) as! DiaryEntryCell
        
        if let entry = viewModel?.entryViewModels[indexPath.row] {
            diaryEntry.bodyText.text = entry.entryText
            diaryEntry.date.text = entry.date
            diaryEntry.score.text = entry.score
            
        }
        return diaryEntry
    }
    
    
}
