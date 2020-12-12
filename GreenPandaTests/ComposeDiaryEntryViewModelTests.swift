//
//  ComposeDiaryEntryViewModelTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 04/11/2020.
//

import XCTest
import Combine
@testable import GreenPanda

class ComposeDiaryEntryViewModelTests: XCTestCase {
    var anyCancellable: AnyCancellable?
    let someEntryText = "Some example content"
    let someDate = Date(timeIntervalSince1970: 123456)
    let someScore = 4
    
    func testThatWhenComposeIsPressedEntryIsAddedToModel() throws {
        let mockGreenPandaModel = MockGreenPandaModel()
        
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: mockGreenPandaModel)
        composeDiaryEntryViewModel.date = someDate
        composeDiaryEntryViewModel.entryText = someEntryText
        composeDiaryEntryViewModel.score = someScore

        composeDiaryEntryViewModel.composeButtonPressed(failedValidation: {})
        
        let lastEntryAdded = try XCTUnwrap(mockGreenPandaModel.entriesBackingValue.last)
        XCTAssertEqual(lastEntryAdded.timestamp, someDate)
        XCTAssertEqual(lastEntryAdded.entryText, someEntryText)
        XCTAssertEqual(lastEntryAdded.score, someScore)
    }
    
    func testThatGivenDateIsNilWhenComposeIsPressedErrorCallbackIsInvoked() throws {
        let someEntryText = "Some example content"
        let someScore = 4
        let mockGreenPandaModel = MockGreenPandaModel()
        
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: mockGreenPandaModel)
        composeDiaryEntryViewModel.entryText = someEntryText
        composeDiaryEntryViewModel.score = someScore

        var failedValidationInvoked = false
        composeDiaryEntryViewModel.composeButtonPressed {
            failedValidationInvoked = true
        }
        
        XCTAssertTrue(failedValidationInvoked)
    }
    
    func testThatGivenEntryIsNilWhenComposeIsPressedErrorCallbackIsInvoked() throws {
        let mockGreenPandaModel = MockGreenPandaModel()
        
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: mockGreenPandaModel)
        composeDiaryEntryViewModel.date = someDate
        composeDiaryEntryViewModel.score = someScore

        composeDiaryEntryViewModel.composeButtonPressed(failedValidation: {})
        
        var failedValidationInvoked = false
        composeDiaryEntryViewModel.composeButtonPressed {
            failedValidationInvoked = true
        }
        
        XCTAssertTrue(failedValidationInvoked)
    }
    
    func testThatGivenScoreIsNilWhenComposeIsPressedErrorCallbackIsInvoked() throws {
        let mockGreenPandaModel = MockGreenPandaModel()
        
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: mockGreenPandaModel)
        composeDiaryEntryViewModel.date = someDate
        composeDiaryEntryViewModel.entryText = someEntryText

        composeDiaryEntryViewModel.composeButtonPressed(failedValidation: {})
        
        var failedValidationInvoked = false
        composeDiaryEntryViewModel.composeButtonPressed {
            failedValidationInvoked = true
        }
        
        XCTAssertTrue(failedValidationInvoked)
    }
    
    func testThatExpectedNumberOfMoodScoresIsReturned() {
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: MockGreenPandaModel())
        XCTAssertEqual(composeDiaryEntryViewModel.numberOfMoodScores, 5)
    }
    
    func testThatExpectedMoodScoreEmojiIsReturned() {
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: MockGreenPandaModel())
        
        XCTAssertEqual(composeDiaryEntryViewModel.moodScore(for: 0), "😩")
        XCTAssertEqual(composeDiaryEntryViewModel.moodScore(for: 1), "😕")
        XCTAssertEqual(composeDiaryEntryViewModel.moodScore(for: 2), "😐")
        XCTAssertEqual(composeDiaryEntryViewModel.moodScore(for: 3), "🙂")
        XCTAssertEqual(composeDiaryEntryViewModel.moodScore(for: 4), "😁")
    }
    
    func testThatWhenSliderChanges_MoodLabelIsUpdated() {
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: MockGreenPandaModel())
        var capturedLabel: String?
        anyCancellable = composeDiaryEntryViewModel.$moodLabel.sink(receiveValue: { newLabel in
            capturedLabel = newLabel
        })
        
        composeDiaryEntryViewModel.moodSliderUpdated(to: 0)
        XCTAssertEqual(capturedLabel, "Mood: 😩")
        composeDiaryEntryViewModel.moodSliderUpdated(to: 1.4)
        XCTAssertEqual(capturedLabel, "Mood: 😕")
        composeDiaryEntryViewModel.moodSliderUpdated(to: 1.7)
        XCTAssertEqual(capturedLabel, "Mood: 😐")
        composeDiaryEntryViewModel.moodSliderUpdated(to: 3)
        XCTAssertEqual(capturedLabel, "Mood: 🙂")
        composeDiaryEntryViewModel.moodSliderUpdated(to: 4)
        XCTAssertEqual(capturedLabel, "Mood: 😁")
        
    }
    
    func testThatGivenComposeIsTapped_ViewIsDismissed() {
        let mockComposeDiaryEntryCoordinatorDelegate = MockComposeDiaryEntryCoordinatorDelegate()
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: MockGreenPandaModel(), coordinatorDelegate: mockComposeDiaryEntryCoordinatorDelegate)
        composeDiaryEntryViewModel.entryText = ""
        composeDiaryEntryViewModel.date = someDate
        composeDiaryEntryViewModel.score = someScore
        
        composeDiaryEntryViewModel.composeButtonPressed{}
        XCTAssertTrue(mockComposeDiaryEntryCoordinatorDelegate.composeFinishedInvoked)
    }
}

class MockComposeDiaryEntryCoordinatorDelegate: ComposeDiaryEntryCoordinatorDelegate {
    var composeFinishedInvoked = false
    func composeFinished() {
        composeFinishedInvoked = true
    }
    
    
}
