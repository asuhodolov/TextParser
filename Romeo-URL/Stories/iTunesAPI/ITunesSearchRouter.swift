//
//  ITunesSearchRouter.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 17/09/2023.
//

import UIKit

protocol ITunesSearchRouting: AnyObject {}

final class ITunesSearchRouter {
    weak var controller: UIViewController?
    var interactor: ITunesSearchInteractorInput
    
    init(
        controller: UIViewController? = nil,
        interactor: ITunesSearchInteractorInput
    ) {
        self.controller = controller
        self.interactor = interactor
    }
}

extension ITunesSearchRouter: ITunesSearchRouting {}
