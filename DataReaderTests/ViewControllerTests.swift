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

        let apiService = APIServiceMock(data: nil, error: nil)
        let coreDataStack = CoreDataStackMock()
        viewController.coreDataStack = coreDataStack
        viewController.apiService = apiService

        let _ = viewController.view
        viewController.updateTable()

        XCTAssertTrue(coreDataStack.fetchDataWasCalled, "RequestData from apiService should be called and data should be saved")
    }

    func test_updateTable_dataInCoreData_activitiIndicatorStopAnimationShouldBeCalled() {

        let coreDataStack = CoreDataStackMock()
        coreDataStack.numberOfObjects = 1
        viewController.coreDataStack = coreDataStack

        let _ = viewController.view
        viewController.updateTable()

        XCTAssertTrue(!viewController.activitiIndicator.isAnimating, "ActiveIndicator should be stopped")
    }
    
    func test_motionShake() {
        let apiService = APIServiceMock(data: nil, error: nil)
        let coreDataStack = CoreDataStackMock()
        viewController.coreDataStack = coreDataStack
        viewController.apiService = apiService
        
        let _ = viewController.view
        viewController.motionEnded(UIEventSubtype.motionShake, with: nil)
    }
}

class APIServiceMock: APIServiceProtocol {
    func requestData(url: URL, callback: @escaping APIServiceProtocol.completeClosure) {
        requestDataGotCalled = true
    }
    
    var requestDataGotCalled = false
    var data: [String]?
    var error: DataManagerError?
    
    init(data: [String]?, error: DataManagerError?) {
        self.data = data
        self.error = error
    }
}

class CoreDataStackMock: NSObject, CoreDataStackProtocol {
    func saveInCoreDataWith(data: Data?) { saveInCoreDataWithArrayWasCalled = true }
    
    var managedObjectContext: NSManagedObjectContext?
    weak var tableView: UITableView!
    var numberOfObjects: Int = 0
    var saveInCoreDataWithArrayWasCalled = false
    var clearDataWasCalled = false
    var fetchDataWasCalled = false
    
    func getNumberOfObjects() -> Int { return numberOfObjects }
    func fetchData() { fetchDataWasCalled = true }
    func clearData() { clearDataWasCalled = true }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
}
