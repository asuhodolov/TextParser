//
//  AppRouter.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 14/09/2023.
//

import Foundation
import UIKit

public final class ApplicationRouter: NSObject {
    let window: UIWindow
    
    public required init(window: UIWindow) {
        self.window = window
    }
    
    public func presentRootController() {
        let rootController = ModuleAssembler.shared.makeRoot()
        let navigationController = UINavigationController(rootViewController: rootController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
