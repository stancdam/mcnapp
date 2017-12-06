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
    
    var apiService: APIService! = APIService()
    var coreDataStack: CoreDataStackProtocol! = CoreDataStack()
    
    // MARK: - View related
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            updateTable()
        }
    }
    
    // MARK: - Table View support
    
    func updateTable() {
        coreDataStack.fetchData()
    
        let numberOfObjects = coreDataStack.getNumberOfObjects()
        if numberOfObjects == 0 {
            let jsonUrlString = "https://private-5e934f-datatextapi.apiary-mock.com/data"
            guard let url = URL(string: jsonUrlString) else { return }
            
            self.apiService.requestData(url: url) { [unowned self] (data, response, error) -> Void in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.coreDataStack.saveInCoreDataWith(data: data)
                    self.activitiIndicator.stopAnimating()
                }
            }
        } else {
            self.activitiIndicator.stopAnimating()
        }
        print("Update table, fetched results: \(numberOfObjects)")
    }
}
