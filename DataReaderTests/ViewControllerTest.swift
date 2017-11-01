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
    
    func test_viewDidLoad_withNoData_renderZeroRows() {
        let sut = ViewController(dataModel: [])
        
        _ = sut.view
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }
    
    func test_viewDidLoad_withOneData_renderOneRows() {
        let sut = ViewController(dataModel: ["Text1"])
        
        _ = sut.view
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_viewDidLoad_withOneData_renderOneRowsWithText() {
        let sut = ViewController(dataModel: ["Text1"])
        
        _ = sut.view
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath)
        
        XCTAssertEqual(cell?.textLabel?.text, "Text1")
    }
}
