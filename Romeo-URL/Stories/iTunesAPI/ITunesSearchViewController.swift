//
//  ITunesSearchViewController.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 17/09/2023.
//

import UIKit

protocol ITunesSearchPresenterInput: AnyObject {
    func show(albums: [ArtistAlbum])
}

final class ITunesSearchViewController: UITableViewController {
    static let identifier = "ITunesSearchViewController"
    static let albumCellIdentifier = "albumCellIdentifier"
    
    var router: ITunesSearchRouting?
    weak var interactor: ITunesSearchInteractorInput?
    
    private var albums: [ArtistAlbum]?
    private var showActivityIndicator = false
    
// MARK: View Preparation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        interactor?.viewDidLoad()
    }
    
    private func prepareView() {
        title = NSLocalizedString(
            "itunes.navigation.title",
            value: "iTunes Albums",
            comment: "iTunes music search controller navigation bar title")
    }
}


// MARK: - UITableViewDataSource

extension ITunesSearchViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let album = albums?[indexPath.row] else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Self.albumCellIdentifier,
            for: indexPath)
        
        var content = UIListContentConfiguration.cell()
        content.text = album.albumName
        content.secondaryText = "\(album.artistName)"
        content.prefersSideBySideTextAndSecondaryText = false
        cell.contentConfiguration = content

        return cell
    }
}


//MARK: - ITunesSearchPresenterInput

extension ITunesSearchViewController: ITunesSearchPresenterInput {
    func show(albums: [ArtistAlbum]) {
        self.albums = albums
        tableView.reloadData()
    }
}


// MARK: - UISearchBarDelegate

extension ITunesSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor?.searchQueryUpdated(artistName: searchText)
    }
}
