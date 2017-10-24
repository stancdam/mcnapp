//
//  AppDelegate.swift
//  DataReader
//
//  Created by Damian Stanczyk on 23.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let textObjects: [DataTextModel] = {
        let textA = DataText(text: "some textA")
        let textB = DataText(text: "Nulla rutrum bibendum est sodales tincidunt. Donec mattis quam non metus convallis sodales. Fusce commodo tincidunt vestibulum. In hac habitasse platea dictumst. Praesent et sem sed magna fringilla dapibus. Nullam dictum lacus rhoncus nibh vulputate, id sodales tortor mollis")
        let textC = DataText(text: "asjkdla dkajsld aksdj a")
        
        return [DataTextModel(dataText: textA), DataTextModel(dataText: textB), DataTextModel(dataText: textC)]
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

