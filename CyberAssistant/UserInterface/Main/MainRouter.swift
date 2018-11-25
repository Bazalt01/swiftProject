//
//  MainRouter.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 14/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class MainRouter: BaseRouter {
    
    // MARK: - Public
    
    func openTemplatesController() {
        guard let routeHandler = routeHandler else { return }
        let vc = Assembly.shared.configuredTemplateViewController()
        routeHandler.push?(viewController: vc)
    }
    
    func openNewTemplateController() {
        guard let routeHandler = routeHandler else { return }
        let vc = Assembly.shared.configuredTemplateEditViewController(template: nil)
        routeHandler.push?(viewController: vc)
    }
    
    func openSettingsController() {
        guard let routeHandler = routeHandler else { return }
        let vc = Assembly.shared.configuredSettingsViewController()
        routeHandler.push?(viewController: vc)
    }
    
    func openAlertController(title: String, message: String, acceptHandler:os_block_t?, cancelHandler:os_block_t?) {
        guard let routeHandler = routeHandler else { return }
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let accept = acceptHandler {
            let action = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { _ in accept() }
            ac.addAction(action)
        }
        
        if let cancel = cancelHandler {
            let action = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel) { _ in cancel() }
            ac.addAction(action)
        }
        routeHandler.present?(viewController: ac)
    }
}
