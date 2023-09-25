//
//  RepeatsAnalyzerTests.swift
//  Romeo-URLTests
//
//  Created by Alexander Suhodolov on 25/09/2023.
//

import XCTest

class RepeatsAnalyzerTests: XCTestCase {
    static let inputText = "A c a CC cc"
    let repeatsAnalyzer = RepatsAnalyzer()
    
    func testRepeatsSearch() {
        let repeats = repeatsAnalyzer.findRepeats(
            in: Self.inputText,
            using: .words)
        XCTAssert(
            repeats["a"] == 2
                && repeats ["c"] == 1
                && repeats ["cc"] == 2
                && repeats.count == 3,
            "Repeats analyzer's response is wrong")
    }
}
