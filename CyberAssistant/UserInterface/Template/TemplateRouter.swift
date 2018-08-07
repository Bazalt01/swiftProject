//
//  TemplateRouter.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class TemplateRouter {
    var routeHandler: RouterHandler?
    
    func openTemplateEditorController(template: TemplateModel?) {
        if let rh = routeHandler {
            let tc = ViewControllerAssembly.configuredTemplateEditViewController(template: template)
            rh.pushToViewController?(viewController: tc)
        }
    }
}
