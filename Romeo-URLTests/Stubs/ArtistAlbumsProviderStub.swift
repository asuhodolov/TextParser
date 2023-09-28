//
//  ArtistAlbumsProviderStub.swift
//  Romeo-URLTests
//
//  Created by Alexander Suhodolov on 27/09/2023.
//

import Foundation

class ArtistAlbumsProviderStub: ArtistAlbumsProviderProtocol {
    let stubbedAlbums: [ArtistAlbum]
    
    init(stubbedAlbums: [ArtistAlbum]) {
        self.stubbedAlbums = stubbedAlbums
    }
    
    func retrieveAlbums(of artist: String) async throws -> [ArtistAlbum] {
        return stubbedAlbums
    }
}
