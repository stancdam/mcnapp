//
//  DataText.swift
//  DataReader
//
//  Created by Damian Stanczyk on 24.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import Foundation

class DataText {
    // TODO: data model should look a little different but at this point string is just fine
    var text: String?
    
    init(text: String?) {
        self.text = text
    }
}

class DataTextModel {
    private var dataText: DataText?
    var storedText: String?
    
    init(dataText: DataText) {
        self.dataText = dataText
        self.storedText = dataText.text
    }
}
