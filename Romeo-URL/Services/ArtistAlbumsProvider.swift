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
    let webApiManager: WebAPIManagerProtocol
    
    init(webApiManager: WebAPIManagerProtocol) {
        self.webApiManager = webApiManager
    }
    
    public func retrieveAlbums(of artist: String) async throws -> [ArtistAlbum] {
        let requestManager = RequestManager(
            apiManager: webApiManager,
            parser: MusicAlbumsSearchDataParser())
        
        let musicData: MusicInfoResponseData = try await requestManager.perform(
            MusicSearchRequest.searchAlbums(
                artist: artist))
        
        return musicData.albumsData.map {
            ArtistAlbum(
                albumName: $0.collectionName,
                artistName: $0.artistName)
        }
    }
}
