//
//  CoreDataStackTests.swift
//  DataReaderTests
//
//  Created by Damian Stanczyk on 27.11.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import CoreData
import XCTest
@testable import DataReader

class CoreDataStackTest: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = CoreDataStack()
        
        tableView = UITableView()
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "Cell")
        tableView.dataSource = coreDataStack
        
        coreDataStack.tableView = tableView
        coreDataStack.persistentContainer = mockPersistantContainer
    }
    
    override func tearDown() {
        flushData()
        
        super.tearDown()
    }
    
    func test_createDataTextEntityFromText_shouldReturnDataText() {
        
        let dataText = coreDataStack.createDataTextEntityFrom(text: "DataText1")
        
        XCTAssertNotNil(dataText, "DataText not created")
    }
    
    func test_saveInCoreDataWith_1elementArray() {
        
        coreDataStack.saveInCoreDataWith(data: Data.from("[\"DataText1\"]"))
        
        XCTAssertEqual(numberOfItemsInPersistentStore(), 1)
    }

    func test_saveInCoreDataWith_noData() {
        
        coreDataStack.saveInCoreDataWith(data: nil)
        
        XCTAssertEqual(numberOfItemsInPersistentStore(), 0)
    }

    func test_saveInCoreDataWith_1elementData() {
        
        coreDataStack.saveInCoreDataWith(data: Data.from("[\"DataText1\"]"))
        
        XCTAssertEqual(numberOfItemsInPersistentStore(), 1)
    }
    
    func test_saveInCoreDataWith_2elementData() {
        
        coreDataStack.saveInCoreDataWith(data: Data.from("[\"DataText1\",\"DataText2\"]"))
        
        XCTAssertEqual(numberOfItemsInPersistentStore(), 2)
    }
    
    func test_getNumberOfObjects_withNoObjectsInCoreData_shouldReturnZero() {
        
        coreDataStack.fetchData()
        
        XCTAssertEqual(coreDataStack.getNumberOfObjects(), 0)
    }
    
    func test_getNumberOfObjects_withOneObjectInCoreData_shouldReturnOne() {
        
        coreDataStack.saveInCoreDataWith(data: Data.from("[\"DataText1\"]"))
        coreDataStack.fetchData()
        
        XCTAssertEqual(coreDataStack.getNumberOfObjects(), 1)
    }
    
    func test_fetchData_shouldPerformFetch() {
        
        coreDataStack.saveInCoreDataWith(data: Data.from("[\"DataText1\"]"))
        
        XCTAssertTrue(coreDataStack.getNumberOfObjects() != numberOfItemsInPersistentStore(), "Before fetch number of objects in fetchResultControler and persistentStore should differ")
        
        coreDataStack.fetchData()
        
        XCTAssertTrue(coreDataStack.getNumberOfObjects() == numberOfItemsInPersistentStore(), "After fetch number of objects in fetchResultControler and persistentStore should be equal")
    }
    
    func test_clearData_shouldClearCoreDataStack() {
        
        coreDataStack.saveInCoreDataWith(data: Data.from("[\"DataText1\"]"))
        
        coreDataStack.clearData()
        
        XCTAssertEqual(numberOfItemsInPersistentStore(), 0)
    }
    
    func test_numberOfRowsInSection_withNoDataInTableView_shouldReturnZero() {
        
        coreDataStack.fetchData()
        let num = coreDataStack.tableView(tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(num, 0)
    }
    
    func test_numberOfRowsInSection_withDataInTableView_shouldReturnRows() {
        
        coreDataStack.saveInCoreDataWith(data: Data.from("[\"DataText1\"]"))
        coreDataStack.fetchData()
        let num = coreDataStack.tableView(tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(num, 1)
    }
    
    func test_cellForRowAt_shouldReturnCell() {
        
        coreDataStack.saveInCoreDataWith(data: Data.from("[\"DataText1\"]"))
        coreDataStack.fetchData()
        
        let cell = coreDataStack.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(cell, "DataText not created")
    }
    
    //MARK: mock in-memory persistant store
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataTextModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    func flushData() {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "DataText")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        
        try! mockPersistantContainer.viewContext.save()
        
    }
    
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DataText")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }
}

extension Data {
    static func from(_ string: String) -> Data {
        return string.data(using: String.Encoding.utf8)!
    }
}
