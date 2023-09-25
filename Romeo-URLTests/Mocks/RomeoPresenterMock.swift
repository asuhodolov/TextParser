//
//  RomeoPresenterMock.swift
//  Romeo-URLTests
//
//  Created by Alexander Suhodolov on 25/09/2023.
//

import XCTest
import Combine

class RomeoPresenterMock: RomeoPresenterInput, ObservableObject {
    @Published private(set) var showWordsIsCalled = false
    
    var wordsToDisplay: [WordInfo] = []
    var sortOptions: [SortOption] = []
    var selectedSortOption: SortOption?
    
    func show(words: [WordInfo]) {
        wordsToDisplay = words
        showWordsIsCalled = true
    }
    
    func set(sortOptions: [SortOption]) {
        self.sortOptions = sortOptions
    }
    
    func select(sortOption: SortOption) {
        selectedSortOption = sortOption
    }
}
