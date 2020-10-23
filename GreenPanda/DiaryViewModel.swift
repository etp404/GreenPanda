//
//  DiaryViewModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 23/10/2020.
//

import Foundation

struct EntryViewModel {
    let entryText: String
}

class DiaryViewModel {
    
    private let greenPandaModel: GreenPandaModel
    
    init(model greenPandaModel: GreenPandaModel) {
        self.greenPandaModel = greenPandaModel
    }
    
    var numberOfEntries:Int {
        greenPandaModel.entries.count
    }
    
    var entryViewModels: [EntryViewModel] {
        greenPandaModel.entries.map {entry in
            EntryViewModel(entryText: entry.entryText)
        }
    }

}
