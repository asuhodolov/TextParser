//
//  ITunesSearchInteractor.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 17/09/2023.
//

import Foundation
import OSLog

protocol ITunesSearchInteractorInput: AnyObject {
    func viewDidLoad()
    func searchQueryUpdated(artistName: String)
}

final class ITunesSearchInteractor {
    struct Constants {
        static let searchDelay: Double = 0.5
    }
    
    weak var presenter: ITunesSearchPresenterInput?
    weak var router: ITunesSearchRouting?
    
    let albumsProvider: ArtistAlbumsProviderProtocol
    var albums = [ArtistAlbum]()
    var delayedSearchWorkItem: DispatchWorkItem?
    var loadAlbumsTask: Task<Void, Error>?
    
    init(
        presenter: ITunesSearchPresenterInput? = nil,
        router: ITunesSearchRouting? = nil,
        albumsProvider: ArtistAlbumsProviderProtocol
    ) {
        self.presenter = presenter
        self.router = router
        self.albumsProvider = albumsProvider
    }
    
    deinit {
        delayedSearchWorkItem?.cancel()
        loadAlbumsTask?.cancel()
    }
    
    private func retrieveAlbums(of artistName: String) {
        loadAlbumsTask?.cancel()
        loadAlbumsTask = Task {
            do {
                let albums = try await albumsProvider.retrieveAlbums(of: artistName)
                try Task.checkCancellation()
                await processAlbums(albums)
            } catch (let error) {
                Logger.iTunesStoryNamespace.info("Error loading albums: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    private func processAlbums(_ albums: [ArtistAlbum]) {
        self.albums = albums
        presenter?.show(albums: albums)
    }
}


// MARK: - ITunesSearchInteractorInput

extension ITunesSearchInteractor: ITunesSearchInteractorInput {
    func viewDidLoad() {}
    
    func searchQueryUpdated(artistName: String) {
        delayedSearchWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
             self?.retrieveAlbums(of: artistName)
        }
        DispatchQueue.main.asyncAfter(
            deadline: .now() + Self.Constants.searchDelay,
            execute: workItem)
        
        self.delayedSearchWorkItem = workItem
    }
}
