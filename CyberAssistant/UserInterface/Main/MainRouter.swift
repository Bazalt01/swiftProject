//
//  MainRouter.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 14/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class MainRouter: BaseRouter {
    
    // MARK: - Public
    
    func openTemplatesController() {
        if let rh = routeHandler {
            let vc = Assembly.shared.configuredTemplateViewController()
            rh.pushToViewController?(viewController: vc)
        }
    }
    
    func openNewTemplateController() {
        if let rh = routeHandler {
            let vc = Assembly.shared.configuredTemplateEditViewController(template: nil)
            rh.pushToViewController?(viewController: vc)
        }
    }
    
    func openSettingsController() {
        if let rh = routeHandler {
            let vc = Assembly.shared.configuredSettingsViewController()
            rh.pushToViewController?(viewController: vc)
        }
    }
}
