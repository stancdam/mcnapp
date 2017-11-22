//
//  CoreDataStackProtocol.swift
//  DataReader
//
//  Created by Damian Stanczyk on 22.11.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import UIKit
import CoreData

public protocol CoreDataStackProtocol: UITableViewDataSource {
    var managedObjectContext: NSManagedObjectContext? { get set }
    weak var tableView: UITableView! { get set }
    
    func saveInCoreDataWith(array: [String])
    func getNumberOfObjects() -> Int
    func fetchData()
    func clearData()
}
