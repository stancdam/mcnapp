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
//        guard let dataTexts = fetchedResultsController.fetchedObjects else { return 0 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: DataTextViewCell.reuseIdentifier, for: indexPath)
        
//        let textObject = fetchedResultsController.object(at: indexPath)
//
//        if let dynamicCell = cell as? DataTextViewCell {
//            dynamicCell.dataTextView.text = textObject.content
//            dynamicCell.dataTextId.text = String(indexPath.row)
//        }
        
        return UITableViewCell()
    }
}
