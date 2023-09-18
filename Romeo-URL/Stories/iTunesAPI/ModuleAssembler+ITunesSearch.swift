//
//  ModuleAssembler+ITunesSearch.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 17/09/2023.
//

import UIKit

private extension StoryboardName {
    static let iTunesSearch = "ITunesSearchViewController"
}

extension ModuleAssembler {
    func makeITunesSearch() -> UIViewController {
        let storyborad = UIStoryboard(
            name: StoryboardName.iTunesSearch,
            bundle: nil)
        
        guard let viewController = storyborad.instantiateViewController(
            withIdentifier: ITunesSearchViewController.identifier
        ) as? ITunesSearchViewController else {
            assertionFailure("Can not initialize ITunesSearchViewController")
            return UIViewController()
        }
        
        let interactor = ITunesSearchInteractor(albumsProvider: ArtistAlbumsProvider())
        interactor.presenter = viewController
        
        let router = ITunesSearchRouter(
            controller: viewController,
            interactor: interactor)
        viewController.router = router
        viewController.interactor = interactor
        
        return viewController
    }
}
