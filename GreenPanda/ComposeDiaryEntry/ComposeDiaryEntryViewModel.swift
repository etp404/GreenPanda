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
    @Published var moodLabel: String?
    
    private var moodScoreReps = ["😩", "😕", "😐", "🙂", "😁"]
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
    
    func moodSliderUpdated(to moodValue: Float) {
        moodLabel = "Mood: \(moodScoreReps[Int(round(moodValue))])"
    }
    
    func composeButtonPressed(failedValidation:()->Void) {
        guard let date = date,
              let entryText = entryText,
              let score = score else {
            failedValidation()
            return
        }
        self.model.add(entry: DiaryEntry(id: UUID(), timestamp: date, entryText: entryText, score: score))
        coordinatorDelegate?.composeFinished()
    }
}
