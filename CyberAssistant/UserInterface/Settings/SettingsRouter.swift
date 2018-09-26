//
//  SettingsRouter.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 25/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class SettingsRouter {
    var routeHandler: RouterHandler?
    
    // MARK: - Public
    
    func openWelcomeViewController() {
        if let rh = routeHandler {
            let vc = Assembly.shared.configuredWelcomeViewController()
            rh.presentViewController?(viewController: vc)
        }
    }
    
    func popViewController() {
        if let rh = routeHandler {
            rh.popViewController?()
        }
    }
}
