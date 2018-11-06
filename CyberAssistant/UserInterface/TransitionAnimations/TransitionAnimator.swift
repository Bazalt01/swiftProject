//
//  TransitionAnimator.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 30/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

struct Pixel {
    var topLeft: CGPoint
    var topRight: CGPoint
    var bottomRight: CGPoint
    var bottomLeft: CGPoint
}

private let kCountShowingPixels = 20

class TransitionAnimator: NSObject {
}

extension TransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        var targetView = transitionContext.view(forKey: .to)
        if targetView == nil {
            let nc = transitionContext.viewController(forKey: .to)
            assert(nc is UINavigationController)
            let vc = (nc as! UINavigationController).viewControllers.first!
            targetView = vc.view.snapshotView(afterScreenUpdates: true)
        }
        
        guard let view = targetView else {
            transitionContext.completeTransition(true)
            return
        }
        
        let mask = configuredMask(frame: view.bounds)
        let path = UIBezierPath()
        mask.path = path.cgPath
        
        view.layer.mask = mask
        container.addSubview(view)
        
        var pixels = processPixels(frame: view.bounds, pixelSize: AppearanceSize.pixelSize)
        var countPixelRest = pixels.count
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { [weak self] timer in
            guard let `self` = self else { return }
            for _ in 0..<kCountShowingPixels {
                
                let randomIndex = Int(arc4random_uniform(UInt32(countPixelRest - 1)))
                let pixel = pixels[randomIndex]
                path.append(self.bezierPath(pixel: pixel))
                
                pixels.remove(at: randomIndex)
                
                countPixelRest -= 1
                
                guard countPixelRest > 0 else {
                    mask.path = path.cgPath
                    timer.invalidate()
                    transitionContext.completeTransition(true)                
                    return
                }
            }
            mask.path = path.cgPath
        }
    }
    
    private func configuredMask(frame: CGRect) -> CAShapeLayer {
        let mask = CAShapeLayer()
        mask.frame = frame
        mask.fillColor = UIColor.white.cgColor
        return mask
    }
    
    private func bezierPath(pixel: Pixel) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: pixel.topLeft)
        path.addLine(to: pixel.topRight)
        path.addLine(to: pixel.bottomRight)
        path.addLine(to: pixel.bottomLeft)
        path.close()
        return path
    }
    
    private func processPixels(frame: CGRect, pixelSize: CGSize) -> [Pixel] {
        var countHor = frame.width / pixelSize.width
        var countVer = frame.height / pixelSize.height
        
        if countHor.truncatingRemainder(dividingBy: frame.width) > 0.0 {
           countHor = fabs(countHor) + 1.0
        }
        
        if countVer.truncatingRemainder(dividingBy: frame.height) > 0.0 {
            countVer = fabs(countVer) + 1.0
        }
        
        var pixels: [Pixel] = []
        
        for indexV in 0..<Int(countVer) {
            for indexH in 0..<Int(countHor) {
                let iv = CGFloat(indexV)
                let ih = CGFloat(indexH)
                let pixel = Pixel(topLeft: CGPoint(x: ih * pixelSize.width, y: iv * pixelSize.height),
                                  topRight: CGPoint(x: (ih + 1) * pixelSize.width, y: iv * pixelSize.height),
                                  bottomRight: CGPoint(x: (ih + 1) * pixelSize.width, y: (iv + 1) * pixelSize.height),
                                  bottomLeft: CGPoint(x: ih * pixelSize.width, y: (iv + 1) * pixelSize.height))
                pixels.append(pixel)
            }
        }
        return pixels
    }
}
