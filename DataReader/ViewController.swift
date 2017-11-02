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
    
    var textObjects  = Array.createDataModel(size: numOfCells)
    let cellId = "Cell"
    let jsonUrlString = "https://private-5e934f-datatextapi.apiary-mock.com/data"
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        //enableDataChangeFeature()
        
        fetchData()
        
        print(textObjects)
        
    }
    
    func fetchData() {
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            // perhaps check ere
            // check response status
            
            guard let data = data else { return }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String]
                if let stringArray = json {
                    //self.textObjects = stringArray
                    self.updateAllCells(dataModel: stringArray)
                }
                
                //print(self.textObjects)
                
            } catch let jsonErr {
                print("JSON serialiazing errror", jsonErr)
            }
            
            
            }.resume()
    }
    
    func updateCell(atRow: Int) {
        let row = Int(arc4random_uniform(UInt32(atRow)))
        
        guard let cell = tableView.cellForRow(at: IndexPath(item: row, section: 0)) as? DataTextViewCell else {
            return
        }
        
        textObjects[row] = String.randomSentence()
        
        tableView.beginUpdates()
        cell.dataTextView.text = textObjects[row]
        tableView.endUpdates()
    }
    
    func updateAllCells(dataModel: [String]) {
        textObjects = dataModel
        for index in 0..<textObjects.count {
            updateCell(atRow: index)
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
