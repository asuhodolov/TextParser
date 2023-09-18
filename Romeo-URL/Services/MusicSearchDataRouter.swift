//
//  MusicDataRouter.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 17/09/2023.
//

import Foundation
import Alamofire

enum MusicSearchDataRouter: URLRequestConvertible {
    case searchAlbums(artist: String)
    
    struct Constants {
        static let apiBaseUrlString = "https://itunes.apple.com"
    }
    
    var baseURL: URL {
        URL(string: Constants.apiBaseUrlString)!
    }
    
    var path: String {
        switch self {
        case .searchAlbums:
            return "search"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchAlbums:
            return .get
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .searchAlbums(let artist):
            return [
                "term": artist,
                "media": "music",
                "entity": "album",
                "attribute": "artistTerm"]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        switch method {
        case .get:
            request = try URLEncodedFormParameterEncoder().encode(
                parameters,
                into: request)
        case .post:
            request = try JSONParameterEncoder().encode(
                parameters,
                into: request)
        default:
            break
        }
    
        return request
    }
}
