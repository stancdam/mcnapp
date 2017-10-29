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
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateRandomCell), userInfo: nil, repeats: true)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }

    @objc func updateRandomCell() {
        let randomRow = Int(arc4random_uniform(UInt32(textObjects.count)))
        
        guard let cell = tableView.cellForRow(at: IndexPath(item: randomRow, section: 0)) as? DataTextViewCell else {
            return
        }
        
        textObjects[randomRow] = String.randomSentence()
        
        tableView.beginUpdates()
        cell.dataTextView.text = textObjects[randomRow]
        tableView.endUpdates()
    }
}
