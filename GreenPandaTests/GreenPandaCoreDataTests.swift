//
//  GreenPandaCoreDataTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 05/12/2020t
        
import XCTest
import Combine
import CoreData

@testable import GreenPanda

class GreenPandaCoreDataTests: XCTestCase {
    
    private var cancellable: AnyCancellable? = nil

    private var coreDataGreenPandaModel: CoreDataGreenPandaModel!
    
    override func setUp() {
        let managedContext: NSManagedObjectContext = {
            let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
            
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
            try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            
            let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

            return managedObjectContext
        }()
        coreDataGreenPandaModel = CoreDataGreenPandaModel(context: managedContext)
    }
    
    func testThatUpdatesToTheModelAreEmittedToTheSubscriber() {
        var retrievedEntries = [DiaryEntry]()
        cancellable = coreDataGreenPandaModel.entries.sink(receiveValue: { (newEntries:[DiaryEntry]) in
            retrievedEntries = newEntries
        })
        
        XCTAssertEqual(0, retrievedEntries.count)

        let diaryEntryToSave1 = DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 40), entryText: "diaryEntryToSave9", score: 2)
        let diaryEntryToSave2 = DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 40), entryText: "diaryEntryToSave20", score: 2)

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
        let diaryEntryToSave1 = DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 40), entryText: "diaryEntryToSave3", score: 2)
        let diaryEntryToSave2 = DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 40), entryText: "diaryEntryToSave4", score: 2)
        
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
    
}
