//
//  RequestManager.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 27/09/2023.
//

import Foundation

protocol RequestManagerProtocol {
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}

protocol DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T
}

class RequestManager: RequestManagerProtocol {
    let apiManager: WebAPIManagerProtocol
    let parser: DataParserProtocol

    init(
        apiManager: WebAPIManagerProtocol = WebAPIManager(),
        parser: DataParserProtocol
    ) {
        self.apiManager = apiManager
        self.parser = parser
    }
    
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
        let data = try await apiManager.perform(request)
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
}
