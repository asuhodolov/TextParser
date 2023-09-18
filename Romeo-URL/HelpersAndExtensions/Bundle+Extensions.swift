//
//  Bundle+Extensions.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 18/09/2023.
//

import Foundation

private struct Defaults {
    static let bundleIdentifier = "CFBundleIdentifier"
    static let unknownValue = "Unknown value"
}

extension Bundle {
    var identifier: String {
        string(forKey: Defaults.bundleIdentifier)
    }
}


// MARK: - Helpers

private extension Bundle {
    func string(forKey key: String) -> String {
        (infoDictionary?[key] as? String) ?? Defaults.unknownValue
    }
}
