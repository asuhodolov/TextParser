//
//  WebAPIManager.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 27/09/2023.
//

import Foundation

protocol WebAPIManagerProtocol {
    func perform(_ request: RequestProtocol) async throws -> Data
}

class WebAPIManager: WebAPIManagerProtocol {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func perform(_ request: RequestProtocol) async throws -> Data {
        let (data, response) = try await urlSession.data(for: request.makeURLRequest())
        guard let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode)
        else {
            throw NetworkError.invalidServerResponse
        }
        return data
    }
}
