//
//  RomeoInteractor.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 16/09/2023.
//

import Foundation
import OSLog

protocol RomeoInteractorInput: AnyObject {
    func viewDidLoad()
    func userDidSelectSortOption(_ sortOption: SortOption)
}

enum SortOption: CaseIterable {
    case repeatFrequency
    case alphabetically
    case wordLength
}

final class RomeoInteractor {
    private struct Constants {
        static let romeoFileName = "Romeo-and-Juliet"
    }
    
    weak var presenter: RomeoPresenterInput?
    weak var router: RomeoRouting?
    
    private let romeoWordsProvider: RomeoWordsProviderProtocol
    private var wordsInfo = [WordInfo]()
    private let sortOptions: [SortOption] = [
        .repeatFrequency,
        .alphabetically,
        .wordLength
    ]
    private var selectedSortOption: SortOption
    
// MARK: Init
    
    init(
        presenter: RomeoPresenterInput? = nil,
        router: RomeoRouting? = nil,
        romeoWordsProvider: RomeoWordsProviderProtocol
    ) {
        self.presenter = presenter
        self.router = router
        self.romeoWordsProvider = romeoWordsProvider
        self.selectedSortOption = sortOptions.first ?? .repeatFrequency
    }
    
// MARK: Interactor's logic
    
    private func loadRomeoText() {
        Task {
            do {
                let wordsInfo = try await romeoWordsProvider.loadRomeoSplittedByWords()
                await processWords(wordsInfo)
            } catch (let error) {
                Logger.romeoStoryNamespace.info("File loading error: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    private func processWords(_ words: [WordInfo]) {
        wordsInfo = words
        presenter?.show(words: words)
    }
}


// MARK: - RomeoInteractorInput

extension RomeoInteractor: RomeoInteractorInput {
    func viewDidLoad() {
        presenter?.set(sortOptions: sortOptions)
        presenter?.select(sortOption: selectedSortOption)
        loadRomeoText()
    }
    
    func userDidSelectSortOption(_ sortOption: SortOption) {
        guard let index = sortOptions.firstIndex(of: sortOption) else {
            presenter?.select(sortOption: selectedSortOption)
            assertionFailure("Sort options mismatched")
            return
        }
        
        selectedSortOption = sortOptions[index]
        presenter?.select(sortOption: selectedSortOption)
    }
}
