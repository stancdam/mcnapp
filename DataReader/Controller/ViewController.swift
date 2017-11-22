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
        self.updateTable()
    }
    
    
    // MARK: - Gesture recognition support
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            coreDataStack.clearData()
            self.activitiIndicator.isHidden = false
            apiService.requestData(delegate: self)
        }
    }
    
    
    // MARK: - Table View support
    
    func updateTable() {
        do {
            try coreDataStack.fetchedResultsController.performFetch()
            
            if let results = coreDataStack.fetchedResultsController.sections {
                if results[0].numberOfObjects == 0 {
                    apiService.requestData(delegate: self)
                } else {
                    self.activitiIndicator.stopAnimating()
                }
                print("Update table, fetched results: \(results[0].numberOfObjects)")
            }
        } catch let error  {
            print("Error - updateTable: \(error)")
        }
    }
}

extension ViewController: FetchManagerDelegate {
    
    func requestCompleted(data: [String]?, error: DataManagerError?) {
        DispatchQueue.main.async {
            self.activitiIndicator.stopAnimating()
        }
        
        guard let data = data else { return }
        
        DispatchQueue.main.async {
            self.coreDataStack.saveInCoreDataWith(array: data)
        }
    }
    
}
