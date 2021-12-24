//
//  GreenPandaCoreDataTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 05/12/2020t
        
import XCTest
import Combine
import CoreData

@testable import GreenPanda

class MockClock : Clock {
    var date: Date = Date()
}

class GreenPandaCoreDataTests: XCTestCase {
    
    private var cancellable: AnyCancellable? = nil

    private var coreDataGreenPandaModel: CoreDataGreenPandaModel!
    private var mockClock: MockClock!
    private let date1 = Date(timeIntervalSince1970: 40)
    private let date2 = Date(timeIntervalSince1970: 100)

    override func setUp() {
        let managedContext: NSManagedObjectContext = {
            let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
            
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
            try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            
            let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

            return managedObjectContext
        }()
        mockClock = MockClock()
        coreDataGreenPandaModel = CoreDataGreenPandaModel(context: managedContext, clock: mockClock)
    }
    
    func testThatUpdatesToTheModelAreEmittedToTheSubscriber() {
        var retrievedEntries = [DiaryEntry]()
        cancellable = coreDataGreenPandaModel.entriesPublisher.sink(receiveValue: { (newEntries:[DiaryEntry]) in
            retrievedEntries = newEntries
        })
        
        XCTAssertEqual(0, retrievedEntries.count)

        let diaryEntryToSave1 = NewDiaryEntry(id: UUID(), entryText: "diaryEntryToSave9", score: 2)
        let diaryEntryToSave2 = NewDiaryEntry(id: UUID(), entryText: "diaryEntryToSave20", score: 2)

        mockClock.date = date1
        coreDataGreenPandaModel.add(entry: diaryEntryToSave1)
        mockClock.date = date2
        coreDataGreenPandaModel.add(entry: diaryEntryToSave2)


        let retrievedEntry1 = retrievedEntries.filter{ $0.id == diaryEntryToSave1.id}.first
        let retrievedEntry2 = retrievedEntries.filter{ $0.id == diaryEntryToSave2.id}.first
        XCTAssertEqual(2, retrievedEntries.count)
        XCTAssertEqual(date1, retrievedEntry1?.timestamp)
        XCTAssertEqual(diaryEntryToSave1.entryText, retrievedEntry1?.entryText)
        XCTAssertEqual(diaryEntryToSave1.score, retrievedEntry1?.score)
        XCTAssertEqual(date2, retrievedEntry2?.timestamp)
        XCTAssertEqual(diaryEntryToSave2.entryText, retrievedEntry2?.entryText)
        XCTAssertEqual(diaryEntryToSave2.score, retrievedEntry2?.score)
    }
    
    func testThatInitialValueOfTheModelIsGivenToTheSubscriberOnSubscribe() {
        let diaryEntryToSave1 = NewDiaryEntry(id: UUID(), entryText: "diaryEntryToSave3", score: 2)
        let diaryEntryToSave2 = NewDiaryEntry(id: UUID(), entryText: "diaryEntryToSave4", score: 2)
        
        mockClock.date = date1
        coreDataGreenPandaModel.add(entry: diaryEntryToSave1)
        mockClock.date = date2
        coreDataGreenPandaModel.add(entry: diaryEntryToSave2)
        
        var retrievedEntries = [DiaryEntry]()
        cancellable = coreDataGreenPandaModel.entriesPublisher.sink(receiveValue: { (newEntries:[DiaryEntry]) in
            retrievedEntries = newEntries
        })
        let retrievedEntry1 = retrievedEntries.filter{ $0.id == diaryEntryToSave1.id}.first
        let retrievedEntry2 = retrievedEntries.filter{ $0.id == diaryEntryToSave2.id}.first
        XCTAssertEqual(2, retrievedEntries.count)
        XCTAssertEqual(date1, retrievedEntry1?.timestamp)
        XCTAssertEqual(diaryEntryToSave1.entryText, retrievedEntry1?.entryText)
        XCTAssertEqual(diaryEntryToSave1.score, retrievedEntry1?.score)
        XCTAssertEqual(date2, retrievedEntry2?.timestamp)
        XCTAssertEqual(diaryEntryToSave2.entryText, retrievedEntry2?.entryText)
        XCTAssertEqual(diaryEntryToSave2.score, retrievedEntry2?.score)
    }
    
    func testCanDeleteAnEntryById() {
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        coreDataGreenPandaModel.add(entry: NewDiaryEntry(id: id1, entryText: "some diary entry 1", score: 2))
        coreDataGreenPandaModel.add(entry: NewDiaryEntry(id: id2, entryText: "some diary entry 2", score: 2))
        coreDataGreenPandaModel.add(entry: NewDiaryEntry(id: id3, entryText: "some diary entry 3", score: 2))

        coreDataGreenPandaModel.deleteEntry(with: id2)
        
        var retrievedEntries = [DiaryEntry]()
        cancellable = coreDataGreenPandaModel.entriesPublisher.sink(receiveValue: { (newEntries:[DiaryEntry]) in
            retrievedEntries = newEntries
        })
        XCTAssertEqual(2, retrievedEntries.count)
        XCTAssertTrue(retrievedEntries.map({$0.id}).contains(id1))
        XCTAssertTrue(retrievedEntries.map({$0.id}).contains(id3))
    }
    
    //Cover deletion of id that isn't saved.
    
}
