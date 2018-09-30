//
//  WelcomeRouter.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 25/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class WelcomeRouter: BaseRouter {
    
    // MARK: - Public
    
    func openAlertController(message: String) {
        if let rh = routeHandler {
            let ac = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            ac.addAction(action)
            rh.presentViewController?(viewController: ac)
        }
    }
    
    func dismiss() {
        if let rh = routeHandler {
            rh.dismiss?()
        }
    }
}
