//
//  APIServiceTests.swift
//  DataReaderTests
//
//  Created by Damian Stanczyk on 27.11.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import CoreData
import XCTest
@testable import DataReader

class APIServiceTest: XCTestCase {
    
    func test_requestData_checkTheURL() {
        let session = MockURLSession()
        let apiService = APIService(session: session)
        let url = URL(string: "http://testurl.com")!
        
        apiService.requestData(url: url, delegate: FetchManagerMock())
        
        XCTAssertTrue(session.lastURL == url, "ActiveIndicator should be stopped")
    }

    func test_requestData_StartsTheRequest() {
        let dataTask = MockURLSessionDataTask()
        let session = MockURLSession()
        session.nextDataTask = dataTask
        let apiService = APIService(session: session)
        let url = URL(string: "http://testurl.com")!
        
        apiService.requestData(url: url, delegate: FetchManagerMock())
        
        XCTAssert(dataTask.resumeWasCalled)
    }
}

class FetchManagerMock: FetchManagerDelegate {
    
    func requestCompleted(data: [String]?, error: DataManagerError?) {

    }
    
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}

class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?

    func dataTask(with url: URL,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
    {
        lastURL = url
        return nextDataTask
    }
}

