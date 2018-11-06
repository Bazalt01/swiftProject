//
//  SettingsBaseRouter.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 08/10/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class SettingsBaseRouter: BaseRouter {
    
    // MARK: - Public
    
    func popViewController() {
        guard let routeHandler = routeHandler else { return }
        routeHandler.popViewController?()
    }
}
