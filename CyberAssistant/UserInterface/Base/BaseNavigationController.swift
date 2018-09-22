//
//  BaseNavigationController.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 08/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    // MARK: - Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }

    // MARK: - Private
    
    private func configureAppearance() {
        Appearance.applyFor(navigationBar: navigationBar)
    }
}
