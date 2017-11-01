//
//  ViewControllerTest.swift
//  DataReaderTests
//
//  Created by Damian Stanczyk on 01.11.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import Foundation
import XCTest
@testable import DataReader

class ViewControllerTest: XCTestCase {
    
    func test_viewDidLoad_renderRows() {
        XCTAssertEqual(makeSUT(dataModel: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(dataModel: ["T1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(dataModel: ["T1", "T2"]).tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_renderRowsText() {
        XCTAssertEqual(makeSUT(dataModel: ["T1", "T2"]).tableView.text(at: 0), "T1")
        XCTAssertEqual(makeSUT(dataModel: ["T1", "T2"]).tableView.text(at: 1), "T2")
    }
    
    // MARK: Helpers
    
    func makeSUT(dataModel: [String]) -> ViewController {
        let sut = ViewController(dataModel: dataModel)
        _ = sut.view
        return sut
    }
}

private extension UITableView {
    func cell(at row: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: row, section: 0)
        return dataSource?.tableView(self, cellForRowAt: indexPath)
    }
    
    func text(at row: Int) -> String? {
        return cell(at: row)?.textLabel?.text
    }
}
