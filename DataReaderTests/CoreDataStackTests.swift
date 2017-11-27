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
        tableView.register(UITableViewCell.self,
                      forCellReuseIdentifier: "Cell")
        tableView.dataSource = coreDataStack
        coreDataStack.tableView = tableView
        coreDataStack.persistentContainer = mockPersistantContainer
    }
    
    override func tearDown() {
        NotificationCenter.default.removeObserver(self)
        
        flushData()
        
        super.tearDown()
    }
    
    func test_createDataTextEntityFromText_shouldReturnDataText() {
        
        let dataText = coreDataStack.createDataTextEntityFrom(text: "DataText1")
        
        XCTAssertNotNil(dataText, "DataText not created")
    }
    
    func test_saveInCoreDataWith_1elementArray() {
        
        let data = "[\"DataText1\"]".data(using: String.Encoding.utf8)!
        
        coreDataStack.saveInCoreDataWith(data: data)
        
        XCTAssertEqual(numberOfItemsInPersistentStore(), 1)
    }

    func test_saveInCoreDataWith_noData() {
        
        coreDataStack.saveInCoreDataWith(data: nil)
        
        XCTAssertEqual(numberOfItemsInPersistentStore(), 0)
    }

    
    func test_saveInCoreDataWith_2elementArray() {
        
        let data = "[\"DataText1\",\"DataText2\"]".data(using: String.Encoding.utf8)!
        
        coreDataStack.saveInCoreDataWith(data: data)
        
        XCTAssertEqual(numberOfItemsInPersistentStore(), 2)
    }
    
    func test_getNumberOfObjects_shouldReturnOne() {
        
        let data = "[\"DataText1\"]".data(using: String.Encoding.utf8)!
        
        coreDataStack.saveInCoreDataWith(data: data)
        coreDataStack.fetchData()
        
        XCTAssertEqual(coreDataStack.getNumberOfObjects(), 1)
    }
    
    func test_clearData() {
        
        let data = "[\"DataText1\",\"DataText2\"]".data(using: String.Encoding.utf8)!
        
        coreDataStack.saveInCoreDataWith(data: data)
        
        coreDataStack.clearData()
        
        XCTAssertEqual(numberOfItemsInPersistentStore(), 0)
    }
    
    func test_cell() {
        
        let data = "[\"DataText1\",\"DataText2\"]".data(using: String.Encoding.utf8)!
        
        coreDataStack.saveInCoreDataWith(data: data)
        
        coreDataStack.fetchData()
        
        let num = coreDataStack.tableView(tableView, numberOfRowsInSection: 0)
        
        let cell = coreDataStack.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(num, 2)
        
//
//        XCTAssertNotNil(cell, "DataText not created")
        
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
