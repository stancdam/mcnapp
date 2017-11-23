//
//  AppDelegate.swift
//  DataReader
//
//  Created by Damian Stanczyk on 23.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Initialize Storyboard
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate Initial View Controller
        if let viewController = storyboard.instantiateInitialViewController() as? ViewController {

            // Set Root View Controller
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }
       return true
    }
}

