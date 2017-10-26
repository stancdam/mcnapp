//
//  Array+DataModel.swift
//  DataReader
//
//  Created by Damian Stanczyk on 26.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import Foundation

class Array {

    static func createDataModel(size: Int) -> [String] {
        var dataModel = [String]()
        
        for _ in 0 ..< size {
            dataModel.append(String.randomSentence())
        }
        
        return dataModel
    }
}
