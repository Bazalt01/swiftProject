//
//  BaseViewController.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 20/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    let animator = TransitionAnimator()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension BaseViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}
