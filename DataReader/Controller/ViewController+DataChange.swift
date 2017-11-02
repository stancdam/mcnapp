//
//  ViewController+DataChange.swift
//  DataReader
//
//  Created by Damian Stanczyk on 01.11.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import Foundation

extension ViewController {
    
    func enableDataChangeFeature() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(didEnterBackground),
                                       name: NSNotification.Name.UIApplicationWillResignActive,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(didBecomeActive),
                                       name: NSNotification.Name.UIApplicationDidBecomeActive,
                                       object: nil)
    }
    
    @objc func didEnterBackground() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func didBecomeActive() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateRandomCell),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateRandomCell() {
        let randomRow = Int(arc4random_uniform(UInt32(textObjectSize())))
        
        guard let cell = tableView.cellForRow(at: IndexPath(item: randomRow, section: 0)) as? DynamicCell else {
            return
        }
        
        textObjects[randomRow] = String.randomSentence()
        
        tableView.beginUpdates()
        cell.textView.text = textObjects[randomRow]
        tableView.endUpdates()
    }
}
