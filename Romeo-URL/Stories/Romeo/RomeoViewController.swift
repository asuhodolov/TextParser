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

protocol RomeoViewControllerInput {
    func show(words: [WordInfo])
    func set(sortSegments: [SortSegmentInfo])
    func selectSortSegment(at index: Int)
}

final class RomeoViewController: UIViewController, ModuleHolderProtocol {
    static let identifier = "RomeoViewController"
    static let wordCellIdentifier = "wordCellIdentifier"
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var sortLabel: UILabel!
    @IBOutlet private var sortSegmentedControl: UISegmentedControl!
    
    weak var interactor: RomeoInteractorInput?
    var retainedModuleElements = [AnyObject]()
    
    private var wordsInfo = [WordInfo]()
    private var sortSegments: [SortSegmentInfo] = []
    
// MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        interactor?.viewDidLoad()
    }
    
// MARK: View preparation
    
    private func prepareView() {
        prepareNavigationBar()
        sortLabel.text = NSLocalizedString(
            "romeo.label.sortBy",
            value: "Sort by:",
            comment: "Sort section title")
    }
    
    private func prepareNavigationBar() {
        title = NSLocalizedString(
            "romeo.navigation.title",
            value: "Romeo",
            comment: "Romeo controller navigation bar title")
    }
    
    private func prepareSortControls() {
        sortSegmentedControl.removeAllSegments()
        for i in 0..<sortSegments.count {
            let segmentInfo = sortSegments[i]
            let action = UIAction(
                title: segmentInfo.title,
                handler: { [weak interactor] _ in
                    interactor?.userDidSelectSortOption(segmentInfo.sortOption)
                }
            )
            sortSegmentedControl.insertSegment(
                action: action,
                at: i,
                animated: false
            )
        }
    }
}


// MARK: - RomeoPresenterInput

extension RomeoViewController: RomeoViewControllerInput {
    func show(words: [WordInfo]) {
        wordsInfo = words
        tableView.reloadData()
    }
    
    func set(sortSegments: [SortSegmentInfo]) {
        self.sortSegments = sortSegments
        prepareSortControls()
        sortSegmentedControl.selectedSegmentIndex = -1
    }
    
    func selectSortSegment(at index: Int) {
        guard index >= sortSegmentedControl.numberOfSegments else {
            sortSegmentedControl.selectedSegmentIndex = -1
            return
        }
        sortSegmentedControl.selectedSegmentIndex = index
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
