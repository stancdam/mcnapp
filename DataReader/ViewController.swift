//
//  ViewController.swift
//  DataReader
//
//  Created by Damian Stanczyk on 23.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

let numOfCells = 10

import UIKit

class ViewController: UITableViewController {
    
    var textObjects = Array.createDataModel(size: numOfCells)
    let cellId = "Cell"
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        enableDataChangeFeature()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let dynamicCell = cell as? DataTextViewCell {
            dynamicCell.dataTextView.text = textObjects[indexPath.row]
            dynamicCell.dataTextId.text = String(indexPath.row)
        }

        return cell
    }
}
