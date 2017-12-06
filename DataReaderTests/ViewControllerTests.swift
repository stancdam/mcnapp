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
    var coreDataStackMock = CoreDataStackMock()
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.coreDataStack = coreDataStackMock
        let _ = viewController.view
    }
    
    func test_viewDidLoad_tableViewDataSourceShouldBeSet() {
        XCTAssertTrue(viewController.tableView.dataSource != nil, "TableView dataSource should be set")
    }
    
    func test_viewDidLoad_coreDataStackTableViewShouldBeSet() {
        XCTAssertTrue(viewController.coreDataStack.tableView != nil, "CoreDataStack tableView should be set")
    }

    func test_viewDidLoad_tableFooterViewShouldBeSet() {
        XCTAssertTrue(viewController.tableView.tableFooterView != nil, "TableFooterView should be set")
    }

    func test_viewWillAppear_fetchDataShouldBeCalled() {
        viewController.viewWillAppear(false)

        XCTAssertTrue(coreDataStackMock.fetchDataWasCalled, "ViewWillAppear should trigger fetchData")
    }
    
    func test_motionShake() {
        viewController.motionEnded(UIEventSubtype.motionShake, with: nil)
        
        XCTAssertTrue(coreDataStackMock.clearDataWasCalled, "ClearData should be called")
    }

    func test_updateTable_noDataInCoreData_requestDataShouldBeCalled_emptyResponse() {
        let session = MockURLSession()
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        viewController.apiService = APIService(session: session)
        
        viewController.updateTable()
        
        XCTAssertTrue(dataTask.resumeWasCalled, "RequestData from apiService should be called")
    }
    
    func test_updateTable_noDataInCoreData_requestDataShouldBeCalled_dataInResponse() {
        let session = MockURLSession()
        let dataTask = MockURLSessionDataTask()
        session.nextData = "{}".data(using: String.Encoding.utf8)
        session.nextDataTask = dataTask
        session.nextResponse = HTTPURLResponse(url: URL(string: "http://testurl.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        viewController.apiService = APIService(session: session)

        viewController.updateTable()

        DispatchQueue.main.async {
            XCTAssertTrue(self.coreDataStackMock.saveInCoreDataWithArrayWasCalled, "RequestData from apiService should be called and data should be saved")
        }
    }

    func test_updateTable_dataInCoreData_activitiIndicatorStopAnimationShouldBeCalled() {
        let coreDataStack = CoreDataStackMock()
        coreDataStack.numberOfObjects = 1
        viewController.coreDataStack = coreDataStack

        viewController.updateTable()

        XCTAssertTrue(!viewController.activitiIndicator.isAnimating, "ActiveIndicator should be stopped")
    }
}

class CoreDataStackMock: NSObject, CoreDataStackProtocol {
    
    var managedObjectContext: NSManagedObjectContext?
    weak var tableView: UITableView!
    var numberOfObjects: Int = 0
    var saveInCoreDataWithArrayWasCalled = false
    var clearDataWasCalled = false
    var fetchDataWasCalled = false
    
    func getNumberOfObjects() -> Int { return numberOfObjects }
    func fetchData() { fetchDataWasCalled = true }
    func clearData() { clearDataWasCalled = true }
    func saveInCoreDataWith(data: Data?) { saveInCoreDataWithArrayWasCalled = true }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
}
