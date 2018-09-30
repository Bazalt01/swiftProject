//
//  Transitor.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 30/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class Transitor: NSObject {
    let animator = TransitionAnimator()
}

extension Transitor: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}
