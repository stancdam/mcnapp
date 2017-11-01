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
    
    private var textObjects = [String]()
    private let reuseCellId = "Cell"
    
    var timer: Timer?
    
    convenience init(dataModel: [String]) {
        self.init()
        self.textObjects = dataModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

//        enableDataChangeFeature()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueCell(in: tableView)
        cell.textLabel?.text = textObjects[indexPath.row]
        return cell
    }
    
    private func dequeueCell(in tableView: UITableView) ->UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellId) {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: reuseCellId)
    }
}
