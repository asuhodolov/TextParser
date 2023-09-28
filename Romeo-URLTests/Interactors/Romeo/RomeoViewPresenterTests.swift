//
//  RomeoViewPresenterTests.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 28/09/2023.
//

import XCTest

class RomeoViewPresenterTests: XCTestCase {
    static let words: [WordInfo] = [
        .init(word: "c", repeatCount: 1),
        .init(word: "Bbb", repeatCount: 2),
        .init(word: "a", repeatCount: 1)
    ]
    
    var presenter: RomeoViewPresenter!
    var view: RomeoViewControllerMock!
    
    override func setUp() {
        super.setUp()
        
        view = RomeoViewControllerMock()
        presenter = RomeoViewPresenter(view: view)
    }
    
    override func tearDown() {
        super.tearDown()
        
        view = nil
        presenter = nil
    }
    
    func testWordsSorted() {
        presenter.set(sortOptions: [
            .alphabetically,
            .repeatFrequency,
            .wordLength])
        presenter.select(sortOption: .repeatFrequency)
        presenter.show(words: Self.words)
        XCTAssertTrue(
            view.words[0].repeatCount == 2
            && view.words[1].repeatCount == 1,
            "RomeoViewPresenter did failed to apply correct sort")
    }
    
    func testWrongSortIndex() {
        presenter.set(sortOptions: [])
        XCTAssertNoThrow(
            presenter.select(sortOption: .repeatFrequency),
            "RomeoViewPresenter failed to handle unexistent sort option")
        presenter.show(words: Self.words)
        XCTAssertEqual(
            view.words.count, Self.words.count,
            "RomeoViewPresenter failed to show words")
    }
}
