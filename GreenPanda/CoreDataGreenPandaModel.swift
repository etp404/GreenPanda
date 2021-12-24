//
//  CoreDataGreenPandaModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 06/12/2020.
//

import Foundation
import CoreData

class CoreDataGreenPandaModel: GreenPandaModel {
    
    var entriesPublisher: Published<[DiaryEntry]>.Publisher {
        return $entries
    }
    
    @Published public var entries: [DiaryEntry] = []
    
    private let context: NSManagedObjectContext
    private let clock: Clock
    
    init(context: NSManagedObjectContext,
         clock: Clock = DateClock()) {
        self.context = context
        self.clock = clock
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
        updateEntries()
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        updateEntries()
    }
    
    func add(entry: NewDiaryEntry) {
        let diaryEntryEntity = NSEntityDescription.entity(forEntityName: "DiaryEntryEntity",
                                                          in: context)!
        
        let diaryManagedObject = NSManagedObject(entity: diaryEntryEntity,
                                                 insertInto: context)
        diaryManagedObject.setValue(entry.id, forKeyPath: "id")
        diaryManagedObject.setValue(entry.entryText, forKeyPath: "entryText")
        diaryManagedObject.setValue(clock.date, forKeyPath: "timestamp")
        diaryManagedObject.setValue(entry.score, forKeyPath: "score")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteEntry(with id:UUID) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DiaryEntryEntity")
        
        guard let diaryEntries: [NSManagedObject] = try? context.fetch(fetchRequest) else {return}
        context.delete(diaryEntries.first(where: { $0.value(forKey: "id") as! UUID == id })!)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }    }
    
    private func updateEntries() {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "DiaryEntryEntity")
        
        if let diaryEntries: [NSManagedObject] = try? context.fetch(fetchRequest) {
            entries = diaryEntries.compactMap{$0.toDiaryEntry()}
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
