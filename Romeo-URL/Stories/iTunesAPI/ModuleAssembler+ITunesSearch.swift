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
        
        let albumsProvider = ArtistAlbumsProvider(webApiManager: WebAPIManager())
        
        let interactor = ITunesSearchInteractor(albumsProvider: albumsProvider)
        interactor.presenter = viewController
        viewController.interactor = interactor
        
        let router = ITunesSearchRouter(
            controller: viewController,
            interactor: interactor)
        interactor.router = router
        
        viewController.retainedModuleElements = [
            router,
            interactor
        ]
        
        return viewController
    }
}
