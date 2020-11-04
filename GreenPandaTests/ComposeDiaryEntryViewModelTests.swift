//
//  ComposeDiaryEntryViewModelTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 04/11/2020.
//

import XCTest
@testable import GreenPanda

class ComposeDiaryEntryViewModel {
    
    var entryText:String?
    var date: Date?
    var score: Int?
    
    private let model: MockGreenPandaModel
    
    init(model: MockGreenPandaModel) {
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

class ComposeDiaryEntryViewModelTests: XCTestCase {
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
        
        let lastEntryAdded = try XCTUnwrap(mockGreenPandaModel.entries.last)
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
}
