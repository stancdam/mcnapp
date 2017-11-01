//
//  ViewController.swift
//  DataReader
//
//  Created by Damian Stanczyk on 23.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

let numOfCells = 10

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // TODO: this should be private, its not because of the VC+DataChange extension
    var textObjects = [String]()
    private let reuseCellId = "DynamicCell"
    
    var timer: Timer?
    
    convenience init(dataModel: [String]) {
        self.init()
        self.textObjects = dataModel
    }
    
    internal func textObjectSize() -> Int {
        return textObjects.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "DynamicCell", bundle: nil), forCellReuseIdentifier: reuseCellId)
        tableView.tableFooterView = UIView()

        enableDataChangeFeature()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellId, for: indexPath)
        
        if let dynamicCell = cell as? DynamicCell {
            dynamicCell.textView.text = textObjects[indexPath.row]
            dynamicCell.idCell.text = String(indexPath.row)
        }
        
        return cell
    }
}
