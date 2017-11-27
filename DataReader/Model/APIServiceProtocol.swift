//
//  APIServiceProtocol.swift
//  DataReader
//
//  Created by Damian Stanczyk on 19.11.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    func requestData(url: URL, delegate: FetchManagerDelegate)
}
