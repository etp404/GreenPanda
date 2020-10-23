//
//  DiaryViewModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 23/10/2020.
//

import Foundation

class DiaryViewModel {
    
    private let greenPandaModel: GreenPandaModel
    
    init(model greenPandaModel: GreenPandaModel) {
        self.greenPandaModel = greenPandaModel
    }
    
    var numberOfEntries:Int {
        greenPandaModel.entries.count
    }
}
