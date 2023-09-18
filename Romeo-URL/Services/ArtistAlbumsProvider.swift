//
//  ArtistAlbumsProvider.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 17/09/2023.
//

import Foundation
import Alamofire

protocol ArtistAlbumsProviderProtocol {
    func retrieveAlbums(of artist: String) async throws -> [ArtistAlbum]
}

final class ArtistAlbumsProvider: ArtistAlbumsProviderProtocol {
    public func retrieveAlbums(of artist: String) async throws -> [ArtistAlbum] {
        let request = AF.request(MusicSearchDataRouter.searchAlbums(artist: artist))
        let responseValue = try await request
            .validate(statusCode: 200..<300)
            .serializingDecodable(MusicInfoResponseData.self)
            .value
        return responseValue.albumsData.map {
            ArtistAlbum(
                albumName: $0.collectionName,
                artistName: $0.artistName)
        }
    }
}
