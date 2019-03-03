//
//  TemplateRouter.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class TemplateRouter: BaseRouter {
    
    // MARK: - Public
    
    func openTemplateEditorController(template: TemplateModel?) {
        guard let routeHandler = routeHandler else { return }
        let tc = Assembly.shared.templateEditViewController(template: template)
        routeHandler.push?(viewController: tc)
    }
    
    func openTemplateShareController() {
        guard let routeHandler = routeHandler else { return }
        let tc = Assembly.shared.templateShareViewController()
        routeHandler.push?(viewController: tc)
    }
}
