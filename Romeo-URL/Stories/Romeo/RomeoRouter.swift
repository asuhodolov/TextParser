//
//  RomeoRouter.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 16/09/2023.
//

import UIKit

protocol RomeoRouting: AnyObject {}

final class RomeoRouter {
    weak var controller: UIViewController?
    weak var interactor: RomeoInteractorInput?
    
    init(
        controller: UIViewController? = nil,
        interactor: RomeoInteractorInput
    ) {
        self.controller = controller
        self.interactor = interactor
    }
}

extension RomeoRouter: RomeoRouting {}
