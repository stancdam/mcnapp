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

class APIService {
    func requestData(delegate: FetchManagerDelegate)  {
        
        let jsonUrlString = "https://private-5e934f-datatextapi.apiary-mock.com/data"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
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

}
