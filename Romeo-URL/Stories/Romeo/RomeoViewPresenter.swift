//
//  RomeoViewPresenter.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 28/09/2023.
//

import Foundation

protocol RomeoPresenterInput: AnyObject {
    func show(words: [WordInfo])
    func set(sortOptions: [SortOption])
    func select(sortOption: SortOption)
}

struct SortSegmentInfo {
    let sortOption: SortOption
    let title: String
}

class RomeoViewPresenter {
    let view: RomeoViewControllerInput
    var sortOptions = [SortOption]()
    var selectedSortOption: SortOption?
    var words = [WordInfo]()
    
    init(view: RomeoViewControllerInput) {
        self.view = view
    }
    
    private func makeSortSegments(for sortOptions: [SortOption]) -> [SortSegmentInfo] {
        sortOptions.map { SortSegmentInfo(sortOption: $0, title: $0.title) }
    }
    
    private func applySortAndPresentWords() {
        if let selectedSortOption,
           let index = self.sortOptions.firstIndex(of: selectedSortOption)
        {
            view.selectSortSegment(at: index)
            view.show(words: words.sorted(by: selectedSortOption))
        } else if let firstOption = sortOptions.first {
            selectedSortOption = firstOption
            view.selectSortSegment(at: 0)
            view.show(words: words.sorted(by: firstOption))
        } else {
            view.show(words: words)
        }
    }
}

extension RomeoViewPresenter: RomeoPresenterInput {
    func show(words: [WordInfo]) {
        self.words = words
        applySortAndPresentWords()
    }
    
    func set(sortOptions: [SortOption]) {
        self.sortOptions = sortOptions
        view.set(sortSegments: makeSortSegments(for: sortOptions))
        applySortAndPresentWords()
    }
    
    func select(sortOption: SortOption) {
        selectedSortOption = sortOption
        applySortAndPresentWords()
    }
}


// MARK: - SortOption extension

private extension SortOption {
    var title: String {
        switch self {
        case .repeatFrequency:
            return NSLocalizedString(
                "romeo.segmentedControl.repeatCount",
                value: "Repeat count",
                comment: "Sort segmented control option")
        case .alphabetically:
            return NSLocalizedString(
                "romeo.segmentedControl.alphabetically",
                value: "A..Z",
                comment: "Sort segmented control option")
        case .wordLength:
            return NSLocalizedString(
                "romeo.segmentedControl.wordLength",
                value: "Word length",
                comment: "Sort segmented control option")
        }
    }
}


// MARK: - WordInfo Extension

private extension Array<WordInfo> {
    func sorted(by sortOption: SortOption) -> Self {
        switch sortOption {
        case .repeatFrequency:
            return sorted { $0.repeatCount > $1.repeatCount }
        case .alphabetically:
            return sorted { $0.word < $1.word }
        case .wordLength:
            return sorted { $0.word.count > $1.word.count }
        }
    }
}
