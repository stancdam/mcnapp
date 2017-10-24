//
//  ViewController.swift
//  DataReader
//
//  Created by Damian Stanczyk on 23.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var textObjects: [DataTextModel] = (UIApplication.shared.delegate as! AppDelegate).textObjects
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let cellId = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        appDelegate.textChangeDelegate = self
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! DataTextViewCell
        let dataTextViewModel = textObjects[indexPath.row]
        
        cell.dataTextView.text = dataTextViewModel.storedText
        cell.dataTextId.text = String(indexPath.row)
        
        return cell
    }
}

extension ViewController: DataTextChangeDelegate {
    func didTextChangedInArray(atIndex: Int) {

        textObjects = (UIApplication.shared.delegate as! AppDelegate).textObjects
        let dataTextViewModel = textObjects[atIndex]
        
        let indexPath = IndexPath(item: atIndex, section: 0)
        let cell = tableView.cellForRow(at: indexPath)  as! DataTextViewCell
        cell.dataTextView.text = dataTextViewModel.storedText
        
        tableView.reloadData()
        print("... " + dataTextViewModel.storedText!)
    }
}

