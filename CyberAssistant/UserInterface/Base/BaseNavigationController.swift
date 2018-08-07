//
//  BaseNavigationController.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 08/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }
    
    private func configureAppearance() {
        Appearance.applyFor(navigationBar: navigationBar)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
