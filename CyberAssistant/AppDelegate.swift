//
//  AppDelegate.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 07/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        DatabaseManager.database.configure()
        
        let assembly = Assembly.shared
        guard let window = application.windows.first else { return true }
        
        let vc = assembly.configuredMainViewController()
        let navigationController = BaseNavigationController(rootViewController: vc)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        if assembly.authManager.account == nil {
            let wc = assembly.configuredWelcomeViewController()
            navigationController.present(wc, animated: false, completion: nil)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    private func showWelcomeScreenIfNeed(navigationController: UINavigationController) {
    }
}

