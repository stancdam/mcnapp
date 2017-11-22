//
//  DataReaderTests.swift
//  DataReaderTests
//
//  Created by Damian Stanczyk on 23.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import CoreData
import XCTest
@testable import DataReader

class ViewControllerTest: XCTestCase {
    
    func test_requestDataIsCalledIfThereIsNoDataInCoreData() {

        let apiServiceMock = APIServiceMock(data: nil, error: nil)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.apiService = apiServiceMock
        viewController.coreDataStack = CoreDataStackMock()

         _ = viewController.view
        
        XCTAssertTrue(apiServiceMock.requestDataGotCalled, "requestData should have been called")
    }
    
    func test_requestDataIsNotCalledIfThereIsDataInCoreData() {
        
        let apiServiceMock = APIServiceMock(data: nil, error: nil)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.apiService = apiServiceMock
        viewController.coreDataStack = CoreDataStackMock()
        
        _ = viewController.view
        
        XCTAssertTrue(!apiServiceMock.requestDataGotCalled, "requestData should not have been called")
    }
}

class APIServiceMock: APIServiceProtocol {
    var requestDataGotCalled = false
    var data: [String]?
    var error: DataManagerError?
    
    init(data: [String]?, error: DataManagerError?) {
        self.data = data
        self.error = error
    }
    
    func requestData(delegate: FetchManagerDelegate) {
        requestDataGotCalled = true
        delegate.requestCompleted(data: self.data, error: self.error)
    }
}

class CoreDataStackMock: NSObject, CoreDataStackProtocol {
    var managedObjectContext: NSManagedObjectContext?
    weak var tableView: UITableView!
    
    func saveInCoreDataWith(array: [String]) { }
    func getNumberOfObjects() -> Int { return 0 }
    func fetchData() { }
    func clearData() { }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
}
