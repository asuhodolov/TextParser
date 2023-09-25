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
    private var cancellable = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        let textProvider = SourceTextProviderStub(stubbedString: Self.sourceText)
        romeoInteractor = RomeoInteractor(
            textProvider: textProvider,
            repeatsAnalyzer: RepatsAnalyzer())
    }

    override func tearDown() {
        romeoInteractor = nil
        super.tearDown()
    }
    
    func testWordsLoading() {
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
            presenter.wordsToDisplay.firstIndex(of: WordInfo(word: "c", repeatCount: 2)) != nil
            && presenter.wordsToDisplay.firstIndex(of: WordInfo(word: "cas", repeatCount: 1)) != nil
            && presenter.wordsToDisplay.firstIndex(of: WordInfo(word: "a", repeatCount: 3)) != nil
            && presenter.wordsToDisplay.firstIndex(of: WordInfo(word: "aa", repeatCount: 1)) != nil
            && presenter.wordsToDisplay.firstIndex(of: WordInfo(word: "b", repeatCount: 1)) != nil
            && presenter.wordsToDisplay.firstIndex(of: WordInfo(word: "bsd", repeatCount: 1)) != nil
            && presenter.wordsToDisplay.firstIndex(of: WordInfo(word: "longest", repeatCount: 1)) != nil,
            "RomeoInteractor loads and presents wrong words")
    }
    
    func testSortOptionSet() {
        let presenter = RomeoPresenterMock()
        let wordsLoadingFinishExpectation = XCTestExpectation()
        presenter.$showWordsIsCalled
            .sink { called in
                if called {
                    wordsLoadingFinishExpectation.fulfill()
                }
            }.store(in: &cancellable)
        
        romeoInteractor.presenter = presenter
        romeoInteractor.viewDidLoad()
        
        wait(for: [wordsLoadingFinishExpectation], timeout: 1)
        
        romeoInteractor.userDidSelectSortOption(.repeatFrequency)
        XCTAssert(
            presenter.wordsToDisplay[0] == WordInfo(word: "a", repeatCount: 3)
            && presenter.wordsToDisplay[1] == WordInfo(word: "c", repeatCount: 2),
            "RomeoInteractor did set wrong sortOption")
    }
}
