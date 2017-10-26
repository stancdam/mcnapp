//
//  String+RandomWord.swift
//  DataReader
//
//  Created by Damian Stanczyk on 26.10.2017.
//  Copyright © 2017 haze. All rights reserved.
//

import Foundation

extension String {
    
    static func randomWord() -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let randLength = arc4random_uniform(9)+1
        var randomWord = ""
        
        for _ in 0 ..< randLength {
            let rand = arc4random_uniform(UInt32(letters.length))
            var nextChar = letters.character(at: Int(rand))
            randomWord += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomWord
    }
    
    static func randomSentence() -> String {
        let rand = arc4random_uniform(9)+1
        var randomSentence = ""
        
        for _ in 0 ..< rand {
            randomSentence += randomWord() + " "
        }
        
        return randomSentence
    }
}
