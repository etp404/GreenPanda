//
//  CoreDataGreenPandaModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 06/12/2020.
//

import Foundation
import CoreData

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
