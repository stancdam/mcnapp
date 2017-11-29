//
//  APIService.swift
//  DataReader
//
//  Created by Damian Stanczyk on 06.11.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import Foundation

enum DataManagerError: Error {
    case unknown
    case invalidHttpResponse
}

class APIService {
    
    typealias completeClosure = ( _ data: Data?, _ response: URLResponse?, _ error: Error?)->Void
    
    private let session: URLSessionProtocol!
    
    init(session: URLSessionProtocol = URLSession.shared ) {
        self.session = session
    }
    
    func requestData(url: URL, callback: @escaping completeClosure)  {
        self.session.dataTask(with: url) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data else {
                    callback(nil, nil, DataManagerError.invalidHttpResponse)
                    return
            }
            switch(httpResponse.statusCode) {
            case 200:
                callback(receivedData, nil, nil)
            default:
                callback(nil, response, DataManagerError.unknown)
            }

        }.resume()
    }
}

// protocols and extensions below are necessary to create mock and assert the behaviour
// with code below we are able to emulate network behaviour without access to the real network

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionDataTaskProtocol {
    func resume()
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}
