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
        
    func test_requestData_withResponseData_returnsData() {
        
        let session = MockURLSession()
        let dataTask = MockURLSessionDataTask()
        
        let expectedData = "{}".data(using: String.Encoding.utf8)
        session.nextData = expectedData
        session.nextDataTask = dataTask
        
        let apiService = APIService(session: session)
        let url = URL(string: "http://testurl.com")!
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.nextResponse = response
        
        var actualData: Data?
        
        apiService.requestData(url: url) { (data, response, error) -> Void in
            actualData = data
        }
        
        XCTAssertEqual(actualData, expectedData)
    }
    
    func test_requestData_withResponseDataWithInvalidStatucCode_returnsError() {
        
        let session = MockURLSession()
        let dataTask = MockURLSessionDataTask()
        
        let expectedData = "{}".data(using: String.Encoding.utf8)
        session.nextData = expectedData
        session.nextDataTask = dataTask
        
        let apiService = APIService(session: session)
        let url = URL(string: "http://testurl.com")!
        
        let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        session.nextResponse = response
        
        var actualError: Error?
        
        apiService.requestData(url: url) { (data, response, error) -> Void in
            actualError = error
        }
        
        XCTAssertNotNil(actualError)
    }
    
    func test_requestData_withResponseData_returnsError() {
        
        let session = MockURLSession()
        let dataTask = MockURLSessionDataTask()
        
        session.nextError = DataManagerError.unknown
        session.nextDataTask = dataTask
        
        let apiService = APIService(session: session)
        let url = URL(string: "http://testurl.com")!
        
        var actualError: Error?
        
        apiService.requestData(url: url) { (data, response, error) -> Void in
            actualError = error
        }
        
        XCTAssertNotNil(actualError)
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}

class MockURLSession: URLSessionProtocol {
    var nextData: Data?
    var nextError: Error?
    var nextResponse: HTTPURLResponse?
    
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?

    func dataTask(with url: URL,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
    {
        lastURL = url
        completionHandler(nextData, nextResponse, nextError)
        return nextDataTask
    }
}

