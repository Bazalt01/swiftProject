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
    
    func openAlertController(title: String, message: String, acceptHandler:(() -> Void)?, cancelHandler:(() -> Void)?) {
        guard let rh = routeHandler else {
            return
        }
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let accept = acceptHandler {
            let action = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { (alert) in
                accept()
            }
            ac.addAction(action)
        }
        
        if let cancel = cancelHandler {
            let action = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel) { (alert) in
                cancel()
            }
            ac.addAction(action)
        }
        rh.presentViewController?(viewController: ac)
    }
}
