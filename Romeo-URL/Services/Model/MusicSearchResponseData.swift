//
//  MusicSearchResponseData.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 17/09/2023.
//

import Foundation

struct MusicInfoResponseData: Decodable {
    let albumsData: [AlbumData]
    
    enum CodingKeys: String, CodingKey {
        case albumsData = "results"
    }
}

struct AlbumData: Decodable {
    let collectionId: Int
    let collectionName: String
    let artistId: Int
    let artistName: String
    
    enum CodingKeys: String, CodingKey {
        case collectionId
        case collectionName
        case artistId
        case artistName
    }
}
