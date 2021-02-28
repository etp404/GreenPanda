//
//  ComposeDiaryEntryViewModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 07/11/2020.
//

import UIKit

class ComposeDiaryEntryViewModel {
    
    var entryText:String?
    var score: Float? {
        didSet {
            guard let score = score else { return }
            moodLabel = "Mood: \(moodScoreReps[score.roundToInt()])"
        }
    }
    
    @Published var moodLabel: String?
    
    let moodScoreReps = ["😩", "😕", "😐", "🙂", "😁"]
    private let coordinatorDelegate: ComposeDiaryEntryCoordinatorDelegate?
    private let model: GreenPandaModel
    
    init(model: GreenPandaModel,
         coordinatorDelegate: ComposeDiaryEntryCoordinatorDelegate? = nil) {
        self.model = model
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    var numberOfMoodScores: Int { get {
        moodScoreReps.count
    }
    }
    
    func moodScore(for pickerIndex: Int) -> String {
        moodScoreReps[pickerIndex]
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
