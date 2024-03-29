//
//  ComposeDiaryEntryViewModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 07/11/2020.
//

import UIKit

class ComposeDiaryEntryViewModel {
    
    var entryText:String? {
        didSet {
            hideDoneButton = (entryText ?? "").isEmpty || score == nil
        }
    }
    var score: Float? {
        didSet {
            hideDoneButton = (entryText ?? "").isEmpty || score == nil
        }
    }
    let moodScoreReps = ["😩", "😕", "😐", "🙂", "😁"]
    let moodScoreRepImages = [UIImage.init(systemName: "cloud.heavyrain"),
                              UIImage.init(systemName: "cloud.drizzle"),
                              UIImage.init(systemName: "cloud"),
                              UIImage.init(systemName: "cloud.sun"),
                              UIImage.init(systemName: "sun.max")]
    
    @Published private(set) var hideDoneButton = true

    private let coordinatorDelegate: ComposeDiaryEntryCoordinatorDelegate?
    private let model: GreenPandaModel
    
    init(model: GreenPandaModel,
         coordinatorDelegate: ComposeDiaryEntryCoordinatorDelegate? = nil) {
        self.model = model
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    func composeButtonPressed(failedValidation:()->Void) {
        guard let entryText = entryText,
              !entryText.isEmpty,
              let score = score else {
            failedValidation()
            return
        }
        self.model.add(entry: NewDiaryEntry(id: UUID(), entryText: entryText, score: score.roundToInt()))
        coordinatorDelegate?.composeFinished()
    }
    
}

private extension Float {
    func roundToInt() -> Int {
        Int(self.rounded())
    }
}
