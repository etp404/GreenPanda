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
    let someScore:Int  = 4
    let somSliderValue:Float  = 3.7

    func testThatWhenComposeIsPressedEntryIsAddedToModel() throws {
        let mockGreenPandaModel = MockGreenPandaModel()
        mockGreenPandaModel.date = someDate
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: mockGreenPandaModel)
        composeDiaryEntryViewModel.entryText = someEntryText
        composeDiaryEntryViewModel.score = somSliderValue

        composeDiaryEntryViewModel.composeButtonPressed(failedValidation: {})
        
        let lastEntryAdded = try XCTUnwrap(mockGreenPandaModel.entriesBackingValue.last)
        XCTAssertEqual(lastEntryAdded.timestamp, someDate)
        XCTAssertEqual(lastEntryAdded.entryText, someEntryText)
        XCTAssertEqual(lastEntryAdded.score, Int(someScore))
    }

    func testThatGivenEntryIsNilWhenComposeIsPressedErrorCallbackIsInvoked() throws {
        let mockGreenPandaModel = MockGreenPandaModel()
        
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: mockGreenPandaModel)
        composeDiaryEntryViewModel.score = somSliderValue

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
        composeDiaryEntryViewModel.entryText = someEntryText

        composeDiaryEntryViewModel.composeButtonPressed(failedValidation: {})
        
        var failedValidationInvoked = false
        composeDiaryEntryViewModel.composeButtonPressed {
            failedValidationInvoked = true
        }
        
        XCTAssertTrue(failedValidationInvoked)
    }
    
    func testThatExpectedMoodScoreEmojiIsReturned() {
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: MockGreenPandaModel())
        
        XCTAssertEqual(composeDiaryEntryViewModel.moodScoreReps, ["☹️", "🙁", "😐", "🙂", "☺️"])
    }
    
    func testThatGivenComposeIsTapped_ViewIsDismissed() {
        let mockComposeDiaryEntryCoordinatorDelegate = MockComposeDiaryEntryCoordinatorDelegate()
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: MockGreenPandaModel(), coordinatorDelegate: mockComposeDiaryEntryCoordinatorDelegate)
        composeDiaryEntryViewModel.entryText = ""
        composeDiaryEntryViewModel.score = somSliderValue
        
        composeDiaryEntryViewModel.composeButtonPressed{}
        XCTAssertTrue(mockComposeDiaryEntryCoordinatorDelegate.composeFinishedInvoked)
    }
    
    func testThatCannotProceedWhenFieldsAreEmpty() {
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: MockGreenPandaModel(), coordinatorDelegate: MockComposeDiaryEntryCoordinatorDelegate())
        XCTAssertFalse(composeDiaryEntryViewModel.canProceed)
    }
    
    func testThatCannotProceedWhenMoodScoreIsEmpty() {
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: MockGreenPandaModel(), coordinatorDelegate: MockComposeDiaryEntryCoordinatorDelegate())
        composeDiaryEntryViewModel.entryText = "some text"
        XCTAssertFalse(composeDiaryEntryViewModel.canProceed)
    }
    
    func testThatCannotProceedWhenTextEntryIsEmpty() {
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: MockGreenPandaModel(), coordinatorDelegate: MockComposeDiaryEntryCoordinatorDelegate())
        composeDiaryEntryViewModel.score = 4
        XCTAssertFalse(composeDiaryEntryViewModel.canProceed)
    }
    
    func testThatCanProceedWhenScoreThenTextIsEntered() {
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: MockGreenPandaModel(), coordinatorDelegate: MockComposeDiaryEntryCoordinatorDelegate())
        composeDiaryEntryViewModel.score = 4
        composeDiaryEntryViewModel.entryText = "some text"
        XCTAssertTrue(composeDiaryEntryViewModel.canProceed)
    }
    
    func testThatCanProceedWhenTextThenScoreIsEntered() {
        let composeDiaryEntryViewModel = ComposeDiaryEntryViewModel(model: MockGreenPandaModel(), coordinatorDelegate: MockComposeDiaryEntryCoordinatorDelegate())
        composeDiaryEntryViewModel.entryText = "some text"
        composeDiaryEntryViewModel.score = 4
        XCTAssertTrue(composeDiaryEntryViewModel.canProceed)
    }
}

class MockComposeDiaryEntryCoordinatorDelegate: ComposeDiaryEntryCoordinatorDelegate {
    var composeFinishedInvoked = false
    func composeFinished() {
        composeFinishedInvoked = true
    }
    
    
}
