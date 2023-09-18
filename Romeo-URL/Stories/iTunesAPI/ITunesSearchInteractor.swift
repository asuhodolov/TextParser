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
    weak var presenter: ITunesSearchPresenterInput?
    weak var router: ITunesSearchRouting?
    
    let albumsProvider: ArtistAlbumsProviderProtocol
    var albums = [ArtistAlbum]()
    var delayedSearchWorkItem: DispatchWorkItem?
    
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
    }
    
    private func retrieveAlbums(of artistName: String) {
        Task {
            do {
                let albums = try await albumsProvider.retrieveAlbums(of: artistName)
                await MainActor.run { [weak self] in
                    self?.albums = albums
                    self?.presenter?.show(albums: albums)
                }
            } catch (let error) {
                Logger.iTunesStoryNamespace.info("Error loading albums: \(error.localizedDescription)")
            }
        }
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
            deadline: .now() + 0.5,
            execute: workItem)
        
        self.delayedSearchWorkItem = workItem
    }
}
