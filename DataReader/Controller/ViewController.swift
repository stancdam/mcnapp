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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<DataText> = {

        let fetchRequest: NSFetchRequest<DataText> = DataText.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - View related
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateTable()
//        FetchManager.requestData(delegate: self)
    }
    
    // MARK: - Gesture recognition support
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
//            FetchManager.requestData(delegate: self)
        }
    }
    
    // MARK: - Table View support
    
    func updateTable() {
        
        do {
            try self.fetchedResultsController.performFetch()
            
            if let results = self.fetchedResultsController.sections {
                if results[0].numberOfObjects == 0 {
                    APIService.requestData(delegate: self)
                }
            }
//            print("Update table, fetched results: \(String(describing: self.fetchedResultsController.sections?[0].numberOfObjects))")
        } catch let error  {
            print("Error - updateTable: \(error)")
        }
    }
    
    func saveContext() {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Error - saveContext: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    // TODO
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
        print("ayyy it works")
//        DispatchQueue.main.async {
//            self.activitiIndicator.stopAnimating()
//        }
//        
//        guard let data = data else { return }
//        
//        DispatchQueue.main.async {
//            self.textObjects = data
//            self.tableView.reloadData()
//        }
    }
    
}
