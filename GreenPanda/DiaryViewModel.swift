//
//  DiaryViewModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 23/10/2020.
//

import Foundation

struct EntryViewModel {
    let date: String
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm"
        return greenPandaModel.entries.map {entry in
            EntryViewModel(date: dateFormatter.string(from:entry.timestamp), entryText: entry.entryText)
        }
    }

}
