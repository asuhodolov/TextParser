//
//  RomeoViewController.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 16/09/2023.
//

import UIKit

struct WordInfo {
    let word: String
    let repeatCount: Int
}

protocol RomeoPresenterInput: AnyObject {
    func show(words: [WordInfo])
    func set(sortOptions: [SortOption])
    func select(sortOption: SortOption)
}

final class RomeoViewController: UIViewController {
    static let identifier = "RomeoViewController"
    static let wordCellIdentifier = "wordCellIdentifier"
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var sortLabel: UILabel!
    @IBOutlet private var sortSegmentedControl: UISegmentedControl!
    
    var router: RomeoRouting?
    weak var interactor: RomeoInteractorInput?
    
    private var wordsInfo = [WordInfo]()
    private var sortOptions: [SortOption] = []
    private var selectedSortOption: SortOption?
    
// MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        interactor?.viewDidLoad()
    }
    
// MARK: View preparation
    
    private func prepareView() {
        prepareNavigationBar()
        sortLabel.text = "Sort by:"
    }
    
    private func prepareNavigationBar() {
        title = "Romeo"
    }
    
    private func prepareSortControls() {
        sortSegmentedControl.removeAllSegments()
        for i in 0..<sortOptions.count {
            let option = sortOptions[i]
            let action = UIAction(
                title: option.title,
                handler: { [weak interactor] _ in
                    interactor?.userDidSelectSortOption(option)
                }
            )
            sortSegmentedControl.insertSegment(
                action: action,
                at: i,
                animated: false
            )
        }
        guard let selectedOption = self.selectedSortOption,
              let indexOfOption = self.sortOptions.firstIndex(of: selectedOption)
        else {
            sortSegmentedControl.selectedSegmentIndex = 0
            selectedSortOption = sortOptions.first
            return
        }
        sortSegmentedControl.selectedSegmentIndex = indexOfOption
    }
}


// MARK: - RomeoPresenterInput

extension RomeoViewController: RomeoPresenterInput {
    func show(words: [WordInfo]) {
        wordsInfo = words
        tableView.reloadData()
    }
    
    func set(sortOptions: [SortOption]) {
        self.sortOptions = sortOptions
        prepareSortControls()
    }
    
    func select(sortOption: SortOption) {
        guard let indexOfOption = self.sortOptions.firstIndex(of: sortOption) else {
            selectedSortOption = sortOptions.first
            return
        }
        self.selectedSortOption = sortOption
        sortSegmentedControl.selectedSegmentIndex = indexOfOption
    }
}


// MARK: - UITableViewDataSource

extension RomeoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        wordsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RomeoViewController.wordCellIdentifier,
            for: indexPath)
        let wordInfo = wordsInfo[indexPath.row]
        var content = UIListContentConfiguration.cell()
        content.text = wordInfo.word
        content.secondaryText = "\(wordInfo.repeatCount)"
        content.prefersSideBySideTextAndSecondaryText = true
        cell.contentConfiguration = content

        return cell
    }
}


// MARK: - UITableViewDelegate

extension RomeoViewController: UITableViewDelegate {}


// MARK: - SortOption extension

private extension SortOption {
    var title: String {
        switch self {
        case .repeatFrequency:
            return "Repeat count"
        case .alphabetically:
            return "a..A"
        case .wordLength:
            return "Word length"
        }
    }
}
