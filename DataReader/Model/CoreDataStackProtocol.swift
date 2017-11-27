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
    weak var tableView: UITableView! { get set }
    
    func saveInCoreDataWith(data: Data?)
    func getNumberOfObjects() -> Int
    func fetchData()
    func clearData()
}
