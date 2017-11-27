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
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = CoreDataStack()
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
        
//        let data = "{\"DataText1\"}".data(using: String.Encoding.utf8)!
//        do {
//        let jsonData = try JSONSerialization.jsonObject(with: data)
//            coreDataStack.saveInCoreDataWith(data: jsonData)
//        } catch {
//
//        }
//
//        coreDataStack.saveInCoreDataWith(data: data)
//        coreDataStack.saveInCoreDataWith(array: ["DataText1"])
        
        
//        XCTAssertEqual(numberOfItemsInPersistentStore(), 1)
    }
    
    func test_saveInCoreDataWith_2elementArray() {
        
        coreDataStack.saveInCoreDataWith(array: ["DataText1", "DataText2"])
        
        XCTAssertEqual(numberOfItemsInPersistentStore(), 2)
    }
    
    func test_getNumberOfObjects_shouldReturnOne() {
        
        coreDataStack.tableView = UITableView()
        coreDataStack.saveInCoreDataWith(array: ["DataText1"])
//        coreDataStack.fetchData()
        
//        XCTAssertEqual(coreDataStack.getNumberOfObjects(), 1)
    }
    
    func test_saveInCoreDataWith() {
        
        coreDataStack.saveInCoreDataWith(array: ["DataText1", "DataText2"])
        coreDataStack.clearData()
        
        XCTAssertEqual(numberOfItemsInPersistentStore(), 0)
    }
    
    func test_clearData() {
        
        coreDataStack.saveInCoreDataWith(array: ["DataText1", "DataText2"])
        coreDataStack.clearData()
        
        XCTAssertEqual(numberOfItemsInPersistentStore(), 0)
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
