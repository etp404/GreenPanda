//
//  GreenPandaCoreDataTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 05/12/2020t
        
import XCTest
import CoreData
import Combine

@testable import GreenPanda


class CoreDataGreenPandaModel: GreenPandaModel {
    
    var entries: Published<[DiaryEntry]>.Publisher {
        return $entriesBackingValue
    }
    
    @Published private var entriesBackingValue: [DiaryEntry] = []
    
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
    }
    func entriesForGranularTestToGetItStarted()->[DiaryEntry] {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "DiaryEntryEntity")
        
        guard let diaryEntries: [NSManagedObject] = try? context.fetch(fetchRequest) else {
            return []
        }
        
        return diaryEntries.compactMap{$0.toDiaryEntry()}
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "DiaryEntryEntity")
        
        if let diaryEntries: [NSManagedObject] = try? context.fetch(fetchRequest) {
            entriesBackingValue = diaryEntries.compactMap{$0.toDiaryEntry()}
        }
    }
    
    func add(entry: DiaryEntry) {
        let diaryEntryEntity = NSEntityDescription.entity(forEntityName: "DiaryEntryEntity",
                                                          in: context)!
        
        let diaryManagedObject = NSManagedObject(entity: diaryEntryEntity,
                                                 insertInto: context)
        diaryManagedObject.setValue(entry.id, forKeyPath: "id")
        diaryManagedObject.setValue(entry.entryText, forKeyPath: "entryText")
        diaryManagedObject.setValue(entry.timestamp, forKeyPath: "timestamp")
        diaryManagedObject.setValue(entry.score, forKeyPath: "score")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func clear() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DiaryEntryEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not delete all the entries. \(error), \(error.userInfo)")
        }
    }
    
}

fileprivate extension NSManagedObject {
    func toDiaryEntry() -> DiaryEntry? {
        guard let id = value(forKey: "id") as? UUID,
           let entryText = value(forKey: "entryText") as? String,
           let score = value(forKey: "score") as? Int,
           let timestamp = value(forKey: "timestamp") as? Date else {
            return nil
        }
        return DiaryEntry(id: id, timestamp: timestamp, entryText: entryText, score: score)
    }
}

class GreenPandaCoreDataTests: XCTestCase {
    
    private var cancellable: AnyCancellable? = nil

    func testThatDiaryEntryCanBeStoredAndReturnedByTheModel() {
    
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let coreDataGreenPandaModel = CoreDataGreenPandaModel(context: managedContext)
        coreDataGreenPandaModel.clear()
        var retrievedEntries = [DiaryEntry]()
        cancellable = coreDataGreenPandaModel.entries.sink(receiveValue: { (newEntries:[DiaryEntry]) in
            retrievedEntries = newEntries
        })
        XCTAssertEqual(0, coreDataGreenPandaModel.entriesForGranularTestToGetItStarted().count)

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


}
