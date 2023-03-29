//
//  MemoCoreDataManager.swift
//  memo
//
//  Created by Donghoon Bae on 2023/03/17.
//

import Foundation
import CoreData

class MemoCoreDataManager {
    
    static let shared = MemoCoreDataManager(modelName: "Memo")
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores {
            (description, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func createNote() -> Memo {
        let memo = Memo(context: viewContext)
        memo.id = UUID()
        memo.content = ""
        memo.createdOrEditAtDate = Date()
        save()
        return memo
    }
    
    // Saving notes to database
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error occured while saving data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchNotes(filter: String? = nil) -> [Memo] {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Memo.createdOrEditAtDate, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        // filtering notes
        if let filter = filter {
            let pr1 = NSPredicate(format: "title contains[cd] %@", filter)
            let pr2 = NSPredicate(format: "text contains[cd] %@", filter)
            let predicate = NSCompoundPredicate(type: .or, subpredicates: [pr1, pr2])
            request.predicate = predicate
        }
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func deleteNote(_ memo: Memo) {
        viewContext.delete(memo)
        save()
    }
}
