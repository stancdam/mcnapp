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
    
//    var textObjects = [String]() //  = Array.createDataModel(size: 10)
    var timer: Timer?
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataTextModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<DataText> = {

        let fetchRequest: NSFetchRequest<DataText> = DataText.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
//        enableDataChangeFeature()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        FetchManager.requestData(delegate: self)
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
//            FetchManager.requestData(delegate: self)
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
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
