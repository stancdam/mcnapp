//
//  APIServiceProtocol.swift
//  DataReader
//
//  Created by Damian Stanczyk on 19.11.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    
    typealias completeClosure = ( _ data: Data?, _ error: Error?)->Void
    
    func requestData(url: URL, delegate: FetchManagerDelegate)
    func requestData(url: URL, callback: @escaping completeClosure)
}
