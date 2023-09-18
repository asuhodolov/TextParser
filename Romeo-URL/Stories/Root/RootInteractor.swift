//
//  RootInteractor.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 16/09/2023.
//

import Foundation

protocol RootInteractorInput: AnyObject {
    func userDidSelectCell(with identifier: RootCellIdentifier)
}

final class RootInteractor {
    weak var presenter: RootPresenterInput?
    weak var router: RootRouting?
}

extension RootInteractor: RootInteractorInput {
    func userDidSelectCell(with identifier: RootCellIdentifier) {
        switch identifier {
        case .romeo:
            router?.navigateToRomeo()
        case .iTunes:
            router?.navigateToITunes()
        }
    }
}
