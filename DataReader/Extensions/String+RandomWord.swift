//
//  String+RandomWord.swift
//  DataReader
//
//  Created by Damian Stanczyk on 26.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import Foundation

extension String {
    
    static func randomWordAbout(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        var randomWord = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomWord += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomWord
    }
    
    static func randomSentence() -> String {
        let randLimit : UInt32 = 11
        let rand = arc4random_uniform(randLimit)
        var randomSentence = ""
        
        // rand+1 - for at least 1 word in sentence
        for _ in 0 ..< rand+1 {
            let randWordLength = arc4random_uniform(randLimit)
            randomSentence += randomWordAbout(length: Int(randWordLength)) + " "
        }
        
        return randomSentence
    }
}
