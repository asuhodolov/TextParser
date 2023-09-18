//
//  String+Extensions.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 18/09/2023.
//

import Foundation
import UIKit

extension String {
    func containedWords() -> [String] {
        let cfString = self as CFString
        let tokenizer = CFStringTokenizerCreate(
            kCFAllocatorDefault,
            cfString,
            CFRangeMake(0, CFStringGetLength(cfString)),
            kCFStringTokenizerUnitWord,
            CFLocaleCopyCurrent()
        )
        
        var tokens: [String] = []
        var tokenType = CFStringTokenizerTokenType(rawValue: 0)
        
        repeat {
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
            let tokenRange = CFStringTokenizerGetCurrentTokenRange(tokenizer)
            
            if tokenRange.length > 0 {
                let substringRange = CFRange(
                    location: tokenRange.location,
                    length: tokenRange.length)
                let substring = CFStringCreateWithSubstring(
                    kCFAllocatorDefault,
                    cfString,
                    substringRange)
                let token = substring! as String
                tokens.append(token.lowercased())
            }
        } while tokenType != CFStringTokenizerTokenType(rawValue: 0)
        
        return tokens
    }
}
