//
//  SourceTextProviderTest.swift
//  Romeo-URLTests
//
//  Created by Alexander Suhodolov on 27/09/2023.
//

import XCTest

class SourceTextProviderTests: XCTestCase {
    static let inputFileName = "Romeo-and-Juliet-Test"
    var textProvider: TextProviding!
    
    override func setUp() {
        super.setUp()
        textProvider = SourceTextProvider(bundle: Bundle(for: type(of: self)))
    }
    
    override func tearDown() {
        textProvider = nil
        super.tearDown()
    }
    
    func testRepeatsSearch() {
        let text = try? textProvider.loadTextResource(
            name: Self.inputFileName,
            encoding: .macOSRoman)
        XCTAssertEqual(
            text,
            "Two households, both\r(In fair),\r",
            "SourceTextProvider failed to load input file")
    }
    
    func testMissingFile() {
        XCTAssertThrowsError(try textProvider.loadTextResource(
            name: "NoFile",
            encoding: .ascii),
        "SourceTextProvider failed text loading silently")
    }
}
