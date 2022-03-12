//
//  CoreDataGreenPandaModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 06/12/2020.
//

import Foundation
import CoreData

class CoreDataGreenPandaModel: GreenPandaModel {
    
    public static var globalCount = 0

    var entriesPublisher: Published<[DiaryEntry]>.Publisher {
        return $entries
    }
    
    @Published public var entries: [DiaryEntry] = []
    
    private let context: NSManagedObjectContext
    private let clock: Clock
    
    init(context: NSManagedObjectContext,
         clock: Clock = DateClock()) {
        self.context = context
        self.context.automaticallyMergesChangesFromParent = true
        self.clock = clock
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
        updateEntries()
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        updateEntries()
    }
    
    func add(entry: NewDiaryEntry) {
//        let diaryEntryEntity = NSEntityDescription.entity(forEntityName: "DiaryEntryEntity",
//                                                          in: context)!
//
//        let diaryManagedObject = NSManagedObject(entity: diaryEntryEntity,
//                                                 insertInto: context)
//        diaryManagedObject.setValue(entry.id, forKeyPath: "id")
//        diaryManagedObject.setValue(entry.entryText, forKeyPath: "entryText")
//        diaryManagedObject.setValue(clock.date, forKeyPath: "timestamp")
//        diaryManagedObject.setValue(entry.score, forKeyPath: "score")
//
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//        CoreDataGreenPandaModel.globalCount+=1
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
        
//        if let diaryEntries: [NSManagedObject] = try? context.fetch(fetchRequest) {
            entries = [
               
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1642956790.0), entryText: "Feeling a little tired today. Big deadline coming up for the assignment, and had some difficult tutorials. Looking forward to seeing Claire for lunch tomorrow! Went to the centre of town this afternoon, and am due to meet Audrey for dinner later, which will be nice. She’s recently got another dog whom I’m looking forward to meeting. \n \nStarted a yoga class today. I’ve not done physical education since school, and my ligaments were twanging by the end. I did feel well on it once I’d recovered, and I enjoyed having a cup of tea with the other people in the class afterwards. A lot of them had started doing yoga using online tutorials, but said they preferred doing a class with people. I’m planning to go back next week so I can’t have disliked it that much. ", score: 4),
                
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1642861963), entryText: "Went for a few drinks last night with Gwen and Turtle George. We tried one of the new bars down at the marina but it was far too busy, so we retired back to the old town. Gwen was telling me about a singer she’d come across on the radio and we’ve made a vague plan to go and see him when he’s next touring. She’s been struggling with her back lately, so I thought it’d be good for her to have something to look forward to. I’m feeling a bit down today for no particular reason. It might be the time of year. I’m going to ring my brother this evening to have a catch up and hopefully that’ll take me out of it.\n\nYesterday I had to take Toby to the vet. He’s apparently put on rather too much weight. I didn’t tell the vet but I know exactly why this is: the lady down the street puts out food for him so he’s currently having two dinners a day. I’m going to have to knock on and diplomatically ask her to stop. Not particularly looking forward to the conversation but apparently if they eat too much it can affect their joints. I’m meeting Sue at the new exhibit at the art gallery today. It’s very emphatically not my thing but I’ve been told of the virtues of trying new things, and try them I will. I’ve noticed there’s a new Greek place opened opposite the gallery so hopefully we can get dinner afterwards. Feeling rather buoyant today despite feeling a bit  nervous about talking to her down the road about her running buffet. ", score: 3),
                
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1642790623), entryText: "Had a really stressful morning, but feel relieved that I’ve got tomorrow off to relax and have a lazy day! Feel that I’ve rebounded somewhat today. I have made an appointment at the doctor’s which feels like a step in the right direction. Going to be catsitting for Clara in a week or so's time. My allergies have been playing up, so hopefully that won't be a problem. The cat is a tabby, and seems extremely intelligent from what she's said! I've bought her a small rubber mouse for when I go round.", score: 3),
                
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1642686223), entryText: "Really not in a good mood today! I got a parking ticket and it’s for some reason panicked me. I’ve checked and I do just need to pay the fine but I feel absolutely awful about it. I hadn’t seen the lines on the road and now on worried that it’s because I don’t pay enough attention. Didn’t sleep well last night through it. ", score: 1),
                
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1642629523), entryText: "Got back to work today. Carla was on good form, and I had some good feedback on a presentations I gave for a potential new client. I did fluff some numbers here and there, but I was using a powerpoint presentation so I don't think they noticed that I'd said the wrong prices for the some of the premium sized units. I was exhausted when I got in, and was glad that some of that some of the lasagne from last night was still left so I didn't have to cook.\n\nI read an article today about Joyce Grenfell that left me smiling. I'm going to get a book about her from the library when I'm next on that side of town.", score: 3),
                
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1642522363), entryText: "Took Aadi and Asha ice skating today. They’ve really grown up and it was lovely to see how well they’re doing at secondary school. Aadi was proudly telling me about his job at the coffee shop, where he's earning some pocket money, and Asha wsa talking about some of the topics they're covering in history at school.", score: 4),
                
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1642456723), entryText: "Had a really stressful morning today, but feel relieved that I’ve got tomorrow off to relax and have a lazy day! Went to Tesco this afternoon, and due to meet Audrey for dinner later, which will be nice. She’s recently got another dog whom I’m looking forward to meeting.", score: 3),
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1642370323), entryText: "Looking forward to seeing Claire in town for lunch tomorrow! Met my new granddaughter this morning, and took along a few provisions for Gail. Started a new wicker furniture class, which was interesting, although more strenuous than I'd expeced. Brian was interested as he's just had his patio done.", score: 4),
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1642283923), entryText: "I am happy but exhausted having climbed Snowden today. I’ve had a warm bath and planning an early night. Tomorrow I’ve got them all round for Sunday dinner, and I’m going to do some lemon chicken. Looking forward to seeing Carla and Peter and hearing about their trip to Finland.", score: 3),
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1642197523), entryText: "Had quite a bad day today for no particular reason. Called Dev and he’s going to pop by later to watch television. ", score: 0),
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1642612744.0), entryText: "Had a broken night’s sleep yesterday, but things are looking a bit brighter today. The weather hasn’t helped. Going to try to go for a walk to Tesco later to pick up some bits.", score: 1),
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1642111123), entryText: "Feel that I’ve rebounded somewhat today. I have made an appointment at the doctor’s which feels like a step in the right direction.", score: 3),


              
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1642024723), entryText: "Went to the centre of town this afternoon, and due to meet Audrey for dinner later, which will be nice. She’s recently got another dog whom I’m looking forward to meeting.", score: 3),
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1641938323), entryText: "Met my new granddaughter this morning, and took along a few provisions for Gail. ", score: 4),
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1641851923), entryText: "I am happy but exhausted having climbed Snowden today. I’ve had a warm bath and planning an early night. Tomorrow I’ve got them all round for Sunday dinner, and I’m going to do some lemon chucking. Looking forward to seeing Carla and Peter and hearing about their trip to Finland.", score: 3),
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1641765523), entryText: "Had quite a bad day today for no particular reason. Called Dev and he’s going to pop by later to watch television. ", score: 1),
                DiaryEntry(id: UUID(), timestamp: Date(timeIntervalSince1970: 1641679123), entryText: "Took Aadi and Asha ice skating today. They’ve really grown up and it was lovely to see how well they’re doing at secondary school.", score: 4),
            ]
//        }
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
