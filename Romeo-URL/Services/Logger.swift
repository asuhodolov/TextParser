//
//  Logger.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 18/09/2023.
//

import Foundation
import OSLog

extension Logger {
    private static let subsystem = Bundle.main.identifier
    
    static let romeoStoryNamespace = Logger(
        subsystem: subsystem,
        category: "romeoStoryNamespace"
    )
    
    static let iTunesStoryNamespace = Logger(
        subsystem: subsystem,
        category: "iTunesStoryNamespace"
    )
}
