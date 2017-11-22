//
//  CoreDataStack.swift
//  DataReader
//
//  Created by Damian Stanczyk on 07.11.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataStack: NSObject {
    
    weak public var tableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<DataText> = {
        let fetchRequest: NSFetchRequest<DataText> = DataText.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "content", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DataTextModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CoreData stuff?
    
    func createDataTextEntityFrom(text: String) -> NSManagedObject? {
        let viewContext = self.persistentContainer.viewContext
        if let dataTextEntity = NSEntityDescription.insertNewObject(forEntityName: "DataText", into: viewContext) as? DataText {
            dataTextEntity.content = text
            return dataTextEntity
        }
        return nil
    }
    
    func saveInCoreDataWith(array: [String]) {
        _ = array.map{self.createDataTextEntityFrom(text: $0)}
        do {
            try self.persistentContainer.viewContext.save()
        } catch let error {
            print("Error - saveInCoreDataWith: \(error)")
        }
    }
    
    func clearData() {
        do {
            let context = self.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DataText.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                self.saveContext()
            } catch let error {
                print("Error - clearData: \(error)")
            }
        }
    }
}

extension CoreDataStack: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
}

extension CoreDataStack: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataTexts = fetchedResultsController.fetchedObjects else { return 0 }
        return dataTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DataTextViewCell.reuseIdentifier, for: indexPath)
        
        let textObject = fetchedResultsController.object(at: indexPath)

        if let dynamicCell = cell as? DataTextViewCell {
            dynamicCell.dataTextView.text = textObject.content
            dynamicCell.dataTextId.text = String(indexPath.row)
        }
        
        return cell
    }
}
