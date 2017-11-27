//
//  FetchManager.swift
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

protocol FetchManagerDelegate {
    func requestCompleted(data: [String]?, error: DataManagerError?)
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with url: URL,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

class APIService: APIServiceProtocol {
    
    let session: URLSessionProtocol!
    
    typealias completeClosure = ( _ data: Data?, _ error: Error?)->Void
    
    init(session: URLSessionProtocol = URLSession.shared ) {
        self.session = session
    }
    
    func requestData(url: URL, delegate: FetchManagerDelegate)  {
        
        self.session.dataTask(with: url) { (data, response, err) in
            // TODO: check err and response status
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String]
                if let stringArray = json {
                    delegate.requestCompleted(data: stringArray, error: nil)
                }
            } catch {
                delegate.requestCompleted(data: nil, error: .invalidJson)
            }
            
            }.resume()
    }
    
    func requestData(url: URL, callback: @escaping completeClosure)  {
        
        let task = self.session.dataTask(with: url) { (data, response, error) in
            callback(data, error)
        }
        task.resume()
    }
}
