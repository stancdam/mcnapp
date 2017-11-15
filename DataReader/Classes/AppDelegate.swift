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
    let apiService = APIService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Initialize Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate Initial View Controller
        if let viewController = storyboard.instantiateInitialViewController() as? ViewController {
            // Configure View Controller
            viewController.apiService = apiService
            
            // Set Root View Controller
            window?.rootViewController = viewController
        }
       return true
    }
}

