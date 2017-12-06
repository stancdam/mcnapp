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
    
    var apiService: APIService!
    var session: MockURLSession!
    let url = URL(string: "http://testurl.com")!
    
    
    override func setUp() {
        super.setUp()
        
        session = MockURLSession()
        apiService = APIService(session: session)
        
    }
        
    func test_requestData_withResponseData_returnsData() {
        let expectedData = "{}".data(using: String.Encoding.utf8)
        session.nextData = expectedData
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        var actualData: Data?
        
        apiService.requestData(url: url) { (data, response, error) -> Void in
            actualData = data
        }

        XCTAssertEqual(actualData, expectedData)
    }
    
    func test_requestData_withResponseDataWithInvalidStatucCode_returnsError() {
        session.nextData = "{}".data(using: String.Encoding.utf8)
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        var actualError: Error?

        apiService.requestData(url: url) { (data, response, error) -> Void in
            actualError = error
        }

        XCTAssertNotNil(actualError)
    }
    
    func test_requestData_withResponseData_returnsError() {
        session.nextError = DataManagerError.unknown
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

