//
//  RomeoViewControllerMock.swift
//  Romeo-URLTests
//
//  Created by Alexander Suhodolov on 28/09/2023.
//

import Foundation

class RomeoViewControllerMock: RomeoViewControllerInput {
    var words = [WordInfo]()
    var sortSegments = [SortSegmentInfo]()
    var selectedSegmentIndex = 0
    
    func show(words: [WordInfo]) {
        self.words = words
    }
    
    func set(sortSegments: [SortSegmentInfo]) {
        self.sortSegments = sortSegments
    }
    
    func selectSortSegment(at index: Int) {
        selectedSegmentIndex = index
    }
}
