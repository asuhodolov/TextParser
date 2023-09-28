//
//  ModuleAssembler+Root.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 14/09/2023.
//

import UIKit

private extension StoryboardName {
    static let root = "RootViewController"
}

extension ModuleAssembler {
    func makeRoot() -> UIViewController {
        let storyborad = UIStoryboard(
            name: StoryboardName.root,
            bundle: nil)
        
        guard let viewController = storyborad.instantiateViewController(
            withIdentifier: RootViewController.identifier
        ) as? RootViewController else {
            assertionFailure("Can not initialize RootViewController")
            return UIViewController()
        }
        
        let interactor = RootInteractor()
        interactor.presenter = viewController
        viewController.interactor = interactor
        
        let router = RootRouter(
            controller: viewController,
            interactor: interactor)
        interactor.router = router
        
        viewController.retainedModuleElements = [
            interactor,
            router
        ]
                
        return viewController
    }
}
