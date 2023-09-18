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
    
    private let textProvider: TextProviding
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
        textProvider: TextProviding
    ) {
        self.presenter = presenter
        self.router = router
        self.textProvider = textProvider
        self.selectedSortOption = sortOptions.first ?? .repeatFrequency
    }
    
// MARK: Interactor's logic
    
    private func loadRomeoText() {
        Task {
            do {
                let romeoText = try await textProvider.loadTextResource(
                    name: Constants.romeoFileName,
                    encoding: .macOSRoman)
                let wordsFound = findRepeats(text: romeoText ?? "")
                let wordsInfo = wordsFound.map { (key, value) in
                    return WordInfo(
                        word: key,
                        repeatCount: value)
                }.sorted(by: selectedSortOption)
                
                await MainActor.run { [weak self] in
                    self?.wordsInfo = wordsInfo
                    self?.presenter?.show(words: wordsInfo)
                }
            } catch (let error) {
                Logger.romeoStoryNamespace.info("File loading error: \(error.localizedDescription)")
            }
        }
    }
    
    private func findRepeats(text: String) -> [String: Int] {
        var wordsFound = [String: Int]()
        text.enumerateSubstrings(
            in: text.startIndex..<text.endIndex,
            options: .byWords
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


// MARK: - RomeoInteractorInput

extension RomeoInteractor: RomeoInteractorInput {
    func viewDidLoad() {
        loadRomeoText()
        presenter?.set(sortOptions: sortOptions)
        presenter?.select(sortOption: selectedSortOption)
    }
    
    func userDidSelectSortOption(_ sortOption: SortOption) {
        guard let index = sortOptions.firstIndex(of: sortOption) else {
            presenter?.select(sortOption: selectedSortOption)
            assertionFailure("Sort options mismatched")
            return
        }
        
        selectedSortOption = sortOptions[index]
        wordsInfo = wordsInfo.sorted(by: selectedSortOption)
        presenter?.show(words: wordsInfo)
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
