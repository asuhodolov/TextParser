//
//  RepeatsAnalyzer.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 24/09/2023.
//

import Foundation

enum SemanticParsingOption {
    case words
    case centences
}

typealias RepeatsCount = Int

protocol RepeatsDiscovering {
    func findRepeats(
        in text: String,
        using options: SemanticParsingOption
    ) -> [String: RepeatsCount]
}

class RepatsAnalyzer: RepeatsDiscovering {
    func findRepeats(
        in text: String,
        using options: SemanticParsingOption
    ) -> [String: RepeatsCount] {
        var wordsFound = [String: Int]()
        text.enumerateSubstrings(
            in: text.startIndex..<text.endIndex,
            options: options.enumerateOptions
        ) { substring, substringRange, enclosingRange, stop in
            guard let word = substring?.lowercased() else { return }
            
            if let foundWordsCount = wordsFound[word] {
                wordsFound[word] = foundWordsCount + 1
            } else {
                wordsFound[word] = 1
            }
        }
        
        return wordsFound
    }
}

private extension SemanticParsingOption {
    var enumerateOptions: String.EnumerationOptions {
        switch self {
        case .centences:
            return .bySentences
        case .words:
            return .byWords
        }
    }
}
