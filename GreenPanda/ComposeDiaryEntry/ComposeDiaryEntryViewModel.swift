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
            canProceed = !(entryText ?? "").isEmpty && score != nil
        }
    }
    var score: Float? {
        didSet {
            guard let score = score else { return }
            moodLabel = "Mood: \(moodScoreReps[score.roundToInt()])"
        }
    }
    
    @Published var moodLabel: String?
    
    let moodScoreReps = ["☹️", "🙁", "😐", "🙂", "☺️"]
    let moodScoreRepImages = [UIImage.init(systemName: "cloud.heavyrain"),
                              UIImage.init(systemName: "cloud.drizzle"),
                              UIImage.init(systemName: "cloud"),
                              UIImage.init(systemName: "cloud.sun"),
                              UIImage.init(systemName: "sun.max")]
    
    private(set) var canProceed = false

    private let coordinatorDelegate: ComposeDiaryEntryCoordinatorDelegate?
    private let model: GreenPandaModel
    
    init(model: GreenPandaModel,
         coordinatorDelegate: ComposeDiaryEntryCoordinatorDelegate? = nil) {
        self.model = model
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    func composeButtonPressed(failedValidation:()->Void) {
        guard let entryText = entryText,
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
