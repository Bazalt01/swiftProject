//
//  MainRouter.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 14/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class MainRouter {
    var routeHandler: RouterHandler?
    
    // MARK: - Public
    
    func openTemplatesController() {
        if let rh = routeHandler {
            let tc = ViewControllerAssembly.configuredTemplateViewController()
            rh.pushToViewController?(viewController: tc)
        }
    }
    
    func openNewTemplateController() {
        if let rh = routeHandler {
            let tc = ViewControllerAssembly.configuredTemplateEditViewController(template: nil)
            rh.pushToViewController?(viewController: tc)
        }
    }
}
