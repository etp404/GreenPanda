//
//  DiaryEntryCell.swift
//  GreenPanda
//
//  Created by Matthew Mould on 24/10/2020.
//

import UIKit

class DiaryEntryCell: UICollectionViewCell {

    static let reuseIdentifier = "DiaryEntryCell"
    @IBOutlet weak var bodyText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
