//
//  UIImage+Utils.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 18/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

extension UIImage {
    class func ca_image(withFillColor color: UIColor, radius: CGFloat) -> UIImage? {
        let diameter = radius * 2
        let rect = CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter))
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.saveGState()
        
        context.setFillColor(color.cgColor)
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        context.addPath(path.cgPath)
        context.fillPath()
        if !context.isPathEmpty {
            context.clip()
        }
        
        guard var image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
    
        image = image.resizableImage(withCapInsets: UIEdgeInsets(ca_edge: radius), resizingMode: .stretch)
        return image
    }
    
    class func ca_image(imageName: String, renderingMode: UIImageRenderingMode) -> UIImage? {
        return UIImage(named: imageName)?.withRenderingMode(renderingMode)
    }
}
