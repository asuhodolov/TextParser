//
//  AppDelegate.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 14/09/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var appRouter: ApplicationRouter = {
        self.window = UIWindow()
        return ApplicationRouter(window: self.window!)
    }()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        appRouter.presentRootController()
        return true
    }
}

