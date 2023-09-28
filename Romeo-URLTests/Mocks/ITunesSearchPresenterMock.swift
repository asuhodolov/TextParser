//
//  ITunesSearchPresenterMock.swift
//  Romeo-URLTests
//
//  Created by Alexander Suhodolov on 27/09/2023.
//

import Combine

class ITunesSearchPresenterMock: ITunesSearchPresenterInput, ObservableObject {
    @Published private(set) var showAlbumsIsCalled = false
    
    var albumsToDisplay: [ArtistAlbum] = []
    var showAlbumsCallsCount = 0
    
    func show(albums: [ArtistAlbum]) {
        albumsToDisplay = albums
        showAlbumsCallsCount += 1
        showAlbumsIsCalled = true
    }
}
