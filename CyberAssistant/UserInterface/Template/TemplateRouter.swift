//
//  TemplateRouter.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class TemplateRouter: BaseRouter {
    
    // MARK: - Public
    
    func openTemplateEditorController(template: TemplateModel?) {
        if let rh = routeHandler {
            let tc = Assembly.shared.configuredTemplateEditViewController(template: template)
            rh.pushToViewController?(viewController: tc)
        }
    }
    
    func openTemplateShareController() {
        if let rh = routeHandler {
            let tc = Assembly.shared.configuredTemplateShareViewController()
            rh.pushToViewController?(viewController: tc)
        }
    }
}
