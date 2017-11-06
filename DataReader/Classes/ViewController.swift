//
//  ViewController.swift
//  DataReader
//
//  Created by Damian Stanczyk on 23.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!
    
    var textObjects = [String]() //  = Array.createDataModel(size: 10)
    let cellId = "Cell"
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
//        enableDataChangeFeature()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FetchManager.requestData(delegate: self)
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            FetchManager.requestData(delegate: self)
        }
    }
}

extension ViewController: UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return textObjects.count
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    
            if let dynamicCell = cell as? DataTextViewCell {
                dynamicCell.dataTextView.text = textObjects[indexPath.row]
                dynamicCell.dataTextId.text = String(indexPath.row)
            }
    
            return cell
        }
}

extension ViewController: FetchManagerDelegate {
    
    func requestCompleted(data: [String]?, error: DataManagerError?) {
        
        DispatchQueue.main.async {
            self.activitiIndicator.stopAnimating()
        }
        
        guard let data = data else { return }
        
        DispatchQueue.main.async {
            self.textObjects = data
            self.tableView.reloadData()
        }
    }
    
}
