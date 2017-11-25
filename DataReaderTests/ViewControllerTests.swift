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
    
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()

        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_viewDidLoad_tableViewDataSourceShouldBeSet() {

        let _ = viewController.view
        
        XCTAssertTrue(viewController.tableView.dataSource != nil, "TableView dataSource should be set")
    }
    
    func test_viewDidLoad_coreDataStackTableViewShouldBeSet() {
        
        let _ = viewController.view
        
        XCTAssertTrue(viewController.coreDataStack.tableView != nil, "CoreDataStack tableView should be set")
    }
    
    func test_viewDidLoad_tableFooterViewShouldBeSet() {
        
        let _ = viewController.view
        
        XCTAssertTrue(viewController.tableView.tableFooterView != nil, "TableFooterView should be set")
    }
    
    func test_updateTable_noDataInCoreData_requestDataShouldBeCalled_emptyResponse() {
        
        let apiService = APIServiceMock(data: nil, error: nil)
        viewController.coreDataStack = CoreDataStackMock()
        viewController.apiService = apiService
        
        let _ = viewController.view
        viewController.updateTable()
        
        XCTAssertTrue(apiService.requestDataGotCalled, "RequestData from apiService should be called")
    }
    
    func test_viewWillAppear_fetchDataShouldBeCalled() {
        
        let coreDataStack = CoreDataStackMock()
        viewController.coreDataStack = coreDataStack
        
        let _ = viewController.view
        viewController.viewWillAppear(false)
        
        XCTAssertTrue(coreDataStack.fetchDataWasCalled, "ViewWillAppear should trigger fetchData")
    }
    
    func test_updateTable_noDataInCoreData_requestDataShouldBeCalled_dataInResponse() {

        let apiService = APIServiceMock(data: ["Test"], error: nil)
        let coreDataStack = CoreDataStackMock()
        viewController.coreDataStack = coreDataStack
        viewController.apiService = apiService
        
        let _ = viewController.view
        viewController.updateTable()
       
        DispatchQueue.main.async {
            XCTAssertTrue(apiService.requestDataGotCalled && coreDataStack.saveInCoreDataWithArrayWasCalled, "RequestData from apiService should be called and data should be saved")
        }
    }
    
    func test_updateTable_dataInCoreData_activitiIndicatorStopAnimationShouldBeCalled() {

        let coreDataStack = CoreDataStackMock()
        coreDataStack.numberOfObjects = 1
        viewController.coreDataStack = coreDataStack
        
        let _ = viewController.view
        viewController.updateTable()
        
        XCTAssertTrue(!viewController.activitiIndicator.isAnimating, "ActiveIndicator should be stopped")
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
    var numberOfObjects: Int = 0
    var saveInCoreDataWithArrayWasCalled = false
    var clearDataWasCalled = false
    var fetchDataWasCalled = false
    
    func saveInCoreDataWith(array: [String]) { saveInCoreDataWithArrayWasCalled = true }
    func getNumberOfObjects() -> Int { return numberOfObjects }
    func fetchData() { fetchDataWasCalled = true }
    func clearData() { clearDataWasCalled = true }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
}
