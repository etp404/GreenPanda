//
//  DiaryViewController.swift
//  GreenPanda
//
//  Created by Matthew Mould on 24/10/2020.
//

import UIKit

class DiaryViewController: ViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var viewModel:DiaryViewModel?
    
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
        collectionView.dataSource = self
    }

}

extension DiaryViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel?.numberOfEntries ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let diaryEntry = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryEntryCell.reuseIdentifier, for: indexPath) as! DiaryEntryCell
        
        diaryEntry.bodyText.text = "Item \(indexPath.row)"
        return diaryEntry
    }
    
    
}
