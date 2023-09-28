//
//  RomeoWordsProvider.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 27/09/2023.
//

import Foundation

protocol RomeoWordsProviderProtocol {
    func loadRomeoSplittedByWords() async throws -> [WordInfo]
}

final class RomeoWordsProvider: RomeoWordsProviderProtocol {
    private struct Constants {
        static let romeoFileName = "Romeo-and-Juliet"
    }
    
    let textProvider: TextProviding
    let repeatsAnalyzer: RepeatsDiscovering
    
    init(
        textProvider: TextProviding,
        repeatsAnalyzer: RepeatsDiscovering
    ) {
        self.textProvider = textProvider
        self.repeatsAnalyzer = repeatsAnalyzer
    }
    
    func loadRomeoSplittedByWords() async throws -> [WordInfo] {
        let romeoText = try textProvider.loadTextResource(
            name: Constants.romeoFileName,
            encoding: .macOSRoman)
        let repeatsFound = repeatsAnalyzer.findRepeats(
            in: romeoText ?? "",
            using: .words)
        let wordsInfo = repeatsFound.map { (key, value) in
            return WordInfo(
                word: key,
                repeatCount: value)
        }
        return wordsInfo
    }
}
