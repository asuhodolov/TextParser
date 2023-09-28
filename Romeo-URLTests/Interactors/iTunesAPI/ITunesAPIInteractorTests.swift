//
//  ITunesAPIInteractorTests.swift
//  Romeo-URLTests
//
//  Created by Alexander Suhodolov on 27/09/2023.
//

import XCTest
import Combine

class ITunesAPIInteractorTests: XCTestCase {
    static let albums: [ArtistAlbum] = [
        .init(albumName: "Album1", artistName: "Artist1"),
        .init(albumName: "Album2", artistName: "Artist2")
    ]
    var iTunesSearchInteractor: ITunesSearchInteractor!
    var romeoInteractor: RomeoInteractor!
    var cancellable = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        let albumsProvider = ArtistAlbumsProviderStub(stubbedAlbums: Self.albums)
        iTunesSearchInteractor = ITunesSearchInteractor(albumsProvider: albumsProvider)
    }
    
    override func tearDown() {
        iTunesSearchInteractor = nil
        super.tearDown()
    }
    
    func testSearchPerformed() {
        let presenter = ITunesSearchPresenterMock()
        
        let showAlbumsCallExpectation = XCTestExpectation()
        presenter.$showAlbumsIsCalled
            .sink { called in
                if called {
                    showAlbumsCallExpectation.fulfill()
                }
            }.store(in: &cancellable)
        
        iTunesSearchInteractor.presenter = presenter
        iTunesSearchInteractor.searchQueryUpdated(artistName: "Artist")
        
        wait(for: [showAlbumsCallExpectation], timeout: ITunesSearchInteractor.Constants.searchDelay + 0.1)
        
        XCTAssert(
            presenter.albumsToDisplay.count > 0,
            "iTunesSearchInteractor does not display Artists")
    }
}
