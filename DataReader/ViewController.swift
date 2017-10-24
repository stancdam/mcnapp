//
//  ViewController.swift
//  DataReader
//
//  Created by Damian Stanczyk on 23.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let textObjects: [DataTextModel] = (UIApplication.shared.delegate as! AppDelegate).textObjects
    let cellId = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO
    }

}

