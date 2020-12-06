//
//  GreenPandaCoreDataTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 05/12/2020t
        
import XCTest
import Combine

@testable import GreenPanda

class GreenPandaCoreDataTests: XCTestCase {
    
    private var cancellable: AnyCancellable? = nil

    func testThatUpdatesToTheModelAreEmittedToTheSubscriber() {

        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let coreDataGreenPandaModel = CoreDataGreenPandaModel(context: managedContext)
        coreDataGreenPandaModel.clear()
        var retrievedEntries = [DiaryEntry]()
        cancellable = coreDataGreenPandaModel.entries.sink(receiveValue: { (newEntries:[DiaryEntry]) in
            retrievedEntries = newEntries
        })
        
        XCTAssertEqual(0, retrievedEntries.count)

        let diaryEntryToSave1 = DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 40), entryText: "diaryEntryToSave1", score: 2)
        let diaryEntryToSave2 = DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 40), entryText: "diaryEntryToSave1", score: 2)

        coreDataGreenPandaModel.add(entry: diaryEntryToSave1)
        coreDataGreenPandaModel.add(entry: diaryEntryToSave2)


        let retrievedEntry1 = retrievedEntries.filter{ $0.id == diaryEntryToSave1.id}.first
        let retrievedEntry2 = retrievedEntries.filter{ $0.id == diaryEntryToSave2.id}.first
        XCTAssertEqual(2, retrievedEntries.count)
        XCTAssertEqual(diaryEntryToSave1.timestamp, retrievedEntry1?.timestamp)
        XCTAssertEqual(diaryEntryToSave1.entryText, retrievedEntry1?.entryText)
        XCTAssertEqual(diaryEntryToSave1.score, retrievedEntry1?.score)
        XCTAssertEqual(diaryEntryToSave2.timestamp, retrievedEntry2?.timestamp)
        XCTAssertEqual(diaryEntryToSave2.entryText, retrievedEntry2?.entryText)
        XCTAssertEqual(diaryEntryToSave2.score, retrievedEntry2?.score)

    }
    
    func testThatInitialValueOfTheModelIsGivenToTheSubscriberOnSubscribe() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let coreDataGreenPandaModel = CoreDataGreenPandaModel(context: managedContext)
        coreDataGreenPandaModel.clear()
        let diaryEntryToSave1 = DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 40), entryText: "diaryEntryToSave1", score: 2)
        let diaryEntryToSave2 = DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 40), entryText: "diaryEntryToSave1", score: 2)
        
        coreDataGreenPandaModel.add(entry: diaryEntryToSave1)
        coreDataGreenPandaModel.add(entry: diaryEntryToSave2)
        
        var retrievedEntries = [DiaryEntry]()
        cancellable = coreDataGreenPandaModel.entries.sink(receiveValue: { (newEntries:[DiaryEntry]) in
            retrievedEntries = newEntries
        })
        let retrievedEntry1 = retrievedEntries.filter{ $0.id == diaryEntryToSave1.id}.first
        let retrievedEntry2 = retrievedEntries.filter{ $0.id == diaryEntryToSave2.id}.first
        XCTAssertEqual(2, retrievedEntries.count)
        XCTAssertEqual(diaryEntryToSave1.timestamp, retrievedEntry1?.timestamp)
        XCTAssertEqual(diaryEntryToSave1.entryText, retrievedEntry1?.entryText)
        XCTAssertEqual(diaryEntryToSave1.score, retrievedEntry1?.score)
        XCTAssertEqual(diaryEntryToSave2.timestamp, retrievedEntry2?.timestamp)
        XCTAssertEqual(diaryEntryToSave2.entryText, retrievedEntry2?.entryText)
        XCTAssertEqual(diaryEntryToSave2.score, retrievedEntry2?.score)
    }
    
    func testThatTheModelIsInitialisedProperly() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let coreDataGreenPandaModel1 = CoreDataGreenPandaModel(context: managedContext)
        coreDataGreenPandaModel1.clear()
        let diaryEntryToSave1 = DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 40), entryText: "diaryEntryToSave1", score: 2)
        let diaryEntryToSave2 = DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 40), entryText: "diaryEntryToSave1", score: 2)
        coreDataGreenPandaModel1.add(entry: diaryEntryToSave1)
        coreDataGreenPandaModel1.add(entry: diaryEntryToSave2)
        
        let coreDataGreenPandaModel2 = CoreDataGreenPandaModel(context: managedContext)
        var retrievedEntries = [DiaryEntry]()
        cancellable = coreDataGreenPandaModel2.entries.sink(receiveValue: { (newEntries:[DiaryEntry]) in
            retrievedEntries = newEntries
        })
        let retrievedEntry1 = retrievedEntries.filter{ $0.id == diaryEntryToSave1.id}.first
        let retrievedEntry2 = retrievedEntries.filter{ $0.id == diaryEntryToSave2.id}.first
        XCTAssertEqual(2, retrievedEntries.count)
        XCTAssertEqual(diaryEntryToSave1.timestamp, retrievedEntry1?.timestamp)
        XCTAssertEqual(diaryEntryToSave1.entryText, retrievedEntry1?.entryText)
        XCTAssertEqual(diaryEntryToSave1.score, retrievedEntry1?.score)
        XCTAssertEqual(diaryEntryToSave2.timestamp, retrievedEntry2?.timestamp)
        XCTAssertEqual(diaryEntryToSave2.entryText, retrievedEntry2?.entryText)
        XCTAssertEqual(diaryEntryToSave2.score, retrievedEntry2?.score)
    }
}
