//
//  TemplateEditRouter.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class TemplateEditRouter: BaseRouter {
    
    // MARK: - Public
    
    func openAlertController(message: String) {
        guard let routeHandler = routeHandler else { return }
        let ac = UIAlertController(title: NSLocalizedString("attention", comment: ""), message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
        ac.addAction(action)
        routeHandler.present?(viewController: ac)
    }
    
    func backFromEditing() {
        guard let routeHandler = routeHandler else { return }
        routeHandler.popViewController?()
    }
    
    func dismiss() {
        guard let routeHandler = routeHandler else { return }
        routeHandler.dismiss?()
    }
}
