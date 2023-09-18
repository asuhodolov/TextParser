//
//  SourceTextProvider.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 16/09/2023.
//

import Foundation

enum TextLoaderError: Error {
    case FileLoadingFailure
}

protocol TextProviding {
    func loadTextResource(
        name: String,
        encoding: String.Encoding
    ) async throws -> String?
}

class SourceTextProvider: TextProviding {
    func loadTextResource(
        name: String,
        encoding: String.Encoding
    ) async throws -> String? {
        guard let fileURL = Bundle.main.url(
            forResource: name,
            withExtension: "txt")
        else {
            throw TextLoaderError.FileLoadingFailure
        }
        let fileData = try Data(contentsOf: fileURL)
        let decodedString = String(data: fileData, encoding: encoding)
        let replacingQuites = decodedString?.replacingOccurrences(of: "’", with: "&apos;")
        return replacingQuites
    }
}
