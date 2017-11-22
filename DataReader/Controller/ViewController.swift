//
//  ViewController.swift
//  DataReader
//
//  Created by Damian Stanczyk on 23.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: -
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!
    
    var apiService: APIServiceProtocol!
    var coreDataStack: CoreDataStack!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<DataText> = {
        let fetchRequest: NSFetchRequest<DataText> = DataText.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "content", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    // MARK: - View related
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(coreDataStack != nil, "dataProvider is not allowed to be nil at this point")
        tableView.dataSource = coreDataStack
        coreDataStack.tableView = tableView
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.updateTable()
    }
    
    
    // MARK: - Gesture recognition support
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.clearData()
            self.activitiIndicator.isHidden = false
            apiService.requestData(delegate: self)
        }
    }
    
    
    // MARK: - Table View support
    
    func updateTable() {
        do {
//            try self.fetchedResultsController.performFetch()
//            
//            if let results = self.fetchedResultsController.sections {
//                if results[0].numberOfObjects == 0 {
//                    apiService.requestData(delegate: self)
//                } else {
//                    self.activitiIndicator.stopAnimating()
//                }
//                print("Update table, fetched results: \(results[0].numberOfObjects)")
//            }
        } catch let error  {
            print("Error - updateTable: \(error)")
        }
    }
    
    
    // MARK: - CoreData stuff?
    
    private func createDataTextEntityFrom(text: String) -> NSManagedObject? {
        let viewContext = coreDataStack.persistentContainer.viewContext
        if let dataTextEntity = NSEntityDescription.insertNewObject(forEntityName: "DataText", into: viewContext) as? DataText {
            dataTextEntity.content = text
            return dataTextEntity
        }
        return nil
    }
    
    private func saveInCoreDataWith(array: [String]) {
        _ = array.map{self.createDataTextEntityFrom(text: $0)}
        do {
            try coreDataStack.persistentContainer.viewContext.save()
        } catch let error {
            print("Error - saveInCoreDataWith: \(error)")
        }
    }
    
    private func clearData() {
        do {
            let context = coreDataStack.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DataText.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                coreDataStack.saveContext()
            } catch let error {
                print("Error - clearData: \(error)")
            }
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
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

extension ViewController: UITableViewDataSource {

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

extension ViewController: FetchManagerDelegate {
    
    func requestCompleted(data: [String]?, error: DataManagerError?) {
        DispatchQueue.main.async {
            self.activitiIndicator.stopAnimating()
        }
        
        guard let data = data else { return }
        
        DispatchQueue.main.async {
            self.saveInCoreDataWith(array: data)
        }
    }
    
}
