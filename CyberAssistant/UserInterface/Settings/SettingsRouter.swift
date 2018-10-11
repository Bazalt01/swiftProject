//
//  SettingsRouter.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 25/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class SettingsRouter: SettingsBaseRouter {
    
    // MARK: - Public
    
    func openWelcomeViewController() {
        if let rh = routeHandler {
            let vc = Assembly.shared.configuredWelcomeViewController()
            vc.modalPresentationStyle = .overFullScreen
            rh.presentViewController?(viewController: vc)
        }
    }
    
    func openOptionListViewController(options: [TableOption], selectOption: @escaping (_ option: TableOption) -> Void) {
        if let rh = routeHandler {
            let vc = Assembly.shared.configuredSettingsViewController(options: options, selectOption: selectOption)
            rh.pushToViewController?(viewController: vc)
        }
    }        
}
