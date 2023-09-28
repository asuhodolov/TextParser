//
//  ModuleAssembler+Romeo.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 16/09/2023.
//

import UIKit

private extension StoryboardName {
    static let romeo = "RomeoViewController"
}

extension ModuleAssembler {
    func makeRomeo() -> UIViewController {
        let storyborad = UIStoryboard(
            name: StoryboardName.romeo,
            bundle: nil)
        
        guard let viewController = storyborad.instantiateViewController(
            withIdentifier: RomeoViewController.identifier
        ) as? RomeoViewController else {
            assertionFailure("Can not initialize RomeoViewController")
            return UIViewController()
        }
        
        let wordsProvider = RomeoWordsProvider(
            textProvider: SourceTextProvider(bundle: .main),
            repeatsAnalyzer: RepatsAnalyzer())
        let interactor = RomeoInteractor(
            presenter: viewController,
            romeoWordsProvider: wordsProvider)
        
        let router = RomeoRouter(
            controller: viewController,
            interactor: interactor)
        viewController.router = router
        viewController.interactor = interactor
        
        return viewController
    }
}
