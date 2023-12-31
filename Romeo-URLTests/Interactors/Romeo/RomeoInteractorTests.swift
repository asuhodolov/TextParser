//
//  RomeoInteractorTests.swift
//  Romeo-URLTests
//
//  Created by Alexander Suhodolov on 25/09/2023.
//

import XCTest
import Combine

extension WordInfo: Equatable {
    static func == (lhs: WordInfo, rhs: WordInfo) -> Bool {
        return lhs.word == rhs.word
            && lhs.repeatCount == rhs.repeatCount
    }
}

class RomeoInteractorTests: XCTestCase {
    static let sourceText = "c C cas A aa a a b\n bsd longest"
    var romeoInteractor: RomeoInteractor!
    var cancellable = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        let textProvider = SourceTextProviderStub(stubbedString: Self.sourceText)
        let wordsProvider = RomeoWordsProvider(
            textProvider: textProvider,
            repeatsAnalyzer: RepatsAnalyzer())
        romeoInteractor = RomeoInteractor(romeoWordsProvider: wordsProvider)
    }

    override func tearDown() {
        romeoInteractor = nil
        super.tearDown()
    }
    
    func testWordsPresenting() {
        let presenter = RomeoPresenterMock()
        let showWordsCallExpectation = XCTestExpectation()
        presenter.$showWordsIsCalled
            .sink { called in
                if called {
                    showWordsCallExpectation.fulfill()
                }
            }.store(in: &cancellable)
        
        romeoInteractor.presenter = presenter
        romeoInteractor.viewDidLoad()
        
        wait(for: [showWordsCallExpectation], timeout: 1)
        
        XCTAssert(
            presenter.wordsToDisplay.count > 0,
            "RomeoInteractor does not display words")
    }
    
    func testSortOptionSet() {
        let presenter = RomeoPresenterMock()
        romeoInteractor.presenter = presenter
        romeoInteractor.userDidSelectSortOption(.repeatFrequency)
        XCTAssertEqual(
            presenter.selectedSortOption,
            SortOption.repeatFrequency,
            "RomeoInteractor did set wrong sortOption")
    }
}
