//
//  AppDelegate.swift
//  DataReader
//
//  Created by Damian Stanczyk on 23.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import UIKit

protocol DataTextChangeDelegate {
    func didTextChangedInArray(atIndex: Int)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var timer = Timer()
    var textChangeDelegate: DataTextChangeDelegate!
    var textObjects: [DataTextModel] = {
        let textA = DataText(text: "some textA")
        let textB = DataText(text: "Nulla rutrum bibendum est sodales tincidunt. Donec mattis quam non metus convallis sodales. Fusce commodo tincidunt vestibulum. In hac habitasse platea dictumst. Praesent et sem sed magna fringilla dapibus. Nullam dictum lacus rhoncus nibh vulputate, id sodales tortor mollis")
        let textC = DataText(text: "asjkdla dkajsld aksdj a")
        //let textD = DataText(text: "a")
        
        return [DataTextModel(dataText: textA), DataTextModel(dataText: textB), DataTextModel(dataText: textC)]
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(someRandomAction), userInfo: nil, repeats: true)
        return true
    }
    
    @objc func someRandomAction() {
        let randomText = randomString(length: Int(arc4random()%99 + 20))
        let someIndex = Int(arc4random() % 3)
        textObjects[someIndex] = DataTextModel(dataText: DataText(text: randomText))
        textChangeDelegate.didTextChangedInArray(atIndex: someIndex)
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefg hijkl mnopq rstu vwxy zAB CDEF GHI JKLM NOPQRST UVWXY Z012 3456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

