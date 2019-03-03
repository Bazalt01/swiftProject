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
        guard let routeHandler = routeHandler else { return }
        let vc = Assembly.shared.welcomeViewController()
        vc.modalPresentationStyle = .overFullScreen
        routeHandler.present?(viewController: vc)
    }
    
    func openOptionListViewController(options: [TableOption], selectOption: @escaping (_ option: TableOption) -> Void) {
        guard let routeHandler = routeHandler else { return }
        let vc = Assembly.shared.settingsViewController(options: options, selectOption: selectOption)
        routeHandler.push?(viewController: vc)
    }        
}
