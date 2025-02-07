//
//  CoreDataLocalCache.swift
//  MarsApp
//
//  Created by Sreekumar on 07/02/2025.
//

import Foundation
import CoreData

protocol LocalCache {
    func saveMarsImages(_ images: [MarsImage])
    func loadMarsImages() -> [MarsImage]
}

class CoreDataLocalCache: LocalCache {
    
    private let stack = CoreDataStack.shared
    
    func saveMarsImages(_ images: [MarsImage]) {
        let context = stack.context
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CDMarsImage")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error clearing old data: \(error)")
        }
        
        for domainImage in images {
            let cdImage = NSEntityDescription.insertNewObject(forEntityName: "CDMarsImage", into: context)
            cdImage.setValue(domainImage.id, forKey: "id")
            cdImage.setValue(domainImage.title, forKey: "title")
            cdImage.setValue(domainImage.description, forKey: "desc")
            cdImage.setValue(domainImage.dateCreated, forKey: "dateCreated")
            cdImage.setValue(domainImage.imageUrl.absoluteString, forKey: "imageUrl")
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving images to Core Data: \(error)")
        }
        
        for domainImage in images {
            fetchAndStoreImageDataAsync(domainImage)
        }
    }
    
    func loadMarsImages() -> [MarsImage] {
        let context = stack.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDMarsImage")
        
        do {
            let results = try context.fetch(fetchRequest)
            let domainImages = results.compactMap { obj -> MarsImage? in
                guard
                    let id = obj.value(forKey: "id") as? String,
                    let title = obj.value(forKey: "title") as? String,
                    let desc = obj.value(forKey: "desc") as? String,
                    let dateCreated = obj.value(forKey: "dateCreated") as? Date,
                    let imageUrlString = obj.value(forKey: "imageUrl") as? String,
                    let imageUrl = URL(string: imageUrlString)
                else {
                    return nil
                }
                
                let data = obj.value(forKey: "imageData") as? Data
                return MarsImage(
                    id: id,
                    title: title,
                    description: desc,
                    dateCreated: dateCreated,
                    imageUrl: imageUrl,
                    imageData: data
                )
            }
            return domainImages
        } catch {
            print("Error loading images from Core Data: \(error)")
            return []
        }
    }
    
    private func fetchAndStoreImageDataAsync(_ domainImage: MarsImage) {
        
        DispatchQueue.global(qos: .background).async {
            
            guard let data = try? Data(contentsOf: domainImage.imageUrl) else {
                print("Failed to download image data for \(domainImage.id)")
                return
            }
            
            let bgContext = self.stack.newBackgroundContext()
            
            bgContext.performAndWait {
                let fetchReq: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "CDMarsImage")
                fetchReq.predicate = NSPredicate(format: "id == %@", domainImage.id)
                
                do {
                    if let cdObject = try bgContext.fetch(fetchReq).first {
                        cdObject.setValue(data, forKey: "imageData")
                        
                        try bgContext.save()
                    }
                    
                } catch {
                    print("Error saving imageData in background: \(error)")
                }
            }
        }
    }
}

