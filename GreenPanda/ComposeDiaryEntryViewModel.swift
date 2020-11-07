//
//  ComposeDiaryEntryViewModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 07/11/2020.
//

import UIKit

class ComposeDiaryEntryViewModel {
    
    var entryText:String?
    var date: Date?
    var score: Int?
    
    private let model: GreenPandaModel
    
    init(model: GreenPandaModel) {
        self.model = model
    }
    
    func composeButtonPressed(failedValidation:()->Void) {
        guard let date = date,
              let entryText = entryText,
              let score = score else {
            failedValidation()
            return
        }
        self.model.add(entry: DiaryEntry(timestamp: date, entryText: entryText, score: score))
    }
}
