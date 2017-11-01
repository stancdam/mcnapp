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
    
    func test_viewDidLoad_withNoData() {
        let sut = ViewController()
        sut.textObjects = Array.createDataModel(size: 0)
        _ = sut.view
        
        XCTAssertEqual(sut.textObjects.count, 0)
    }
}
