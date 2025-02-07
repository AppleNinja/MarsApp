//
//  CoreDataStack.swift
//  MarsApp
//
//  Created by Sreekumar on 07/02/2025.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MarsApp")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load with error: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving Core Data context: \(error)")
            }
        }
    }
}

