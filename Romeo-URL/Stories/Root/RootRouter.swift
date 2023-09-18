//
//  RootRouter.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 16/09/2023.
//

import UIKit

protocol RootRouting: AnyObject {
    func navigateToRomeo()
    func navigateToITunes()
}

final class RootRouter {
    weak var controller: UIViewController?
    var interactor: RootInteractorInput
    
    init(
        controller: UIViewController? = nil,
        interactor: RootInteractorInput
    ) {
        self.controller = controller
        self.interactor = interactor
    }
}

extension RootRouter: RootRouting {
    func navigateToRomeo() {
        let romeoController = ModuleAssembler.shared.makeRomeo()
        controller?.navigationController?.pushViewController(romeoController, animated: true)
    }
    
    func navigateToITunes() {
        let iTunesSearchContoller = ModuleAssembler.shared.makeITunesSearch()
        controller?.navigationController?.pushViewController(iTunesSearchContoller, animated: true)
    }
}
