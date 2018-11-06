//
//  RouteHandler.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 25/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

@objc protocol RouterHandler {
    @objc optional func push(viewController: UIViewController)
    @objc optional func popViewController()
    @objc optional func present(viewController: UIViewController)
    @objc optional func dismiss()
}
