//
//  ViewController.swift
//  DataReader
//
//  Created by Damian Stanczyk on 23.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var textObjects = [String]() //  = Array.createDataModel(size: 10)
    let cellId = "Cell"
    let jsonUrlString = "https://private-5e934f-datatextapi.apiary-mock.com/data"
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        fetchData()
//        enableDataChangeFeature()
    }
    
    func fetchData() {
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            // TODO: check err and response status
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String]
                if let stringArray = json {
                    self.updateAllCells(dataModel: stringArray)
                }
            } catch let jsonErr {
                print("JSON serialiazing errror", jsonErr)
            }
            
            }.resume()
    }
    
    func updateAllCells(dataModel: [String]) {
        textObjects = dataModel
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            fetchData()
        }
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
