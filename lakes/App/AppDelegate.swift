//
//  AppDelegate.swift
//  lakes
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        DI.instance.container.registerServices()
        setupNavigationAppereance()
        if let window = window {
            let mapLakesConfiguration = MapLakesConfiguration()
            let navigationController = UINavigationController()
            if let viewController = mapLakesConfiguration.viewController {
                navigationController.viewControllers = [viewController]
            }
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            mapLakesConfiguration.configureStart(input: MapLakesConfiguration.Input(transition: .present))
        }
        return true
    }
    
    private func setupNavigationAppereance() {
        UINavigationBar.appearance().barTintColor = Theme.colors.background
        UINavigationBar.appearance().tintColor = Theme.colors.main
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : Theme.colors.main]
    }
}
