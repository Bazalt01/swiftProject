//
//  WelcomeRouter.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 25/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class WelcomeRouter: BaseRouter {
    
    // MARK: - Public
    
    func openAlertController(message: String) {
        guard let routeHandler = routeHandler else { return }
        let ac = UIAlertController(title: NSLocalizedString("attention", comment: ""), message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
        ac.addAction(action)
        routeHandler.present?(viewController: ac)
    }
    
    func dismiss() {
        guard let routeHandler = routeHandler else { return }
        routeHandler.dismiss?()
    }
}
