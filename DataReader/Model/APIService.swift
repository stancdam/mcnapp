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
    case invalidJson
}

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionDataTaskProtocol {
    func resume()
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with url: URL,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

class APIService: APIServiceProtocol {
    
    private let session: URLSessionProtocol!
    
    init(session: URLSessionProtocol = URLSession.shared ) {
        self.session = session
    }
    
    func requestData(url: URL, callback: @escaping completeClosure)  {
        self.session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                callback(nil, DataManagerError.unknown)
            } else {
                callback(data, nil)
            }
        }.resume()
    }
}
