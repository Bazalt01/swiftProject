//
//  UIStructExtention.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 15/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    init(ca_edge edge: CGFloat) {
        self.init(top: edge, left: edge, bottom: edge, right: edge)
    }
    
    mutating func ca_append(insets: UIEdgeInsets) {
        self.top += insets.top
        self.bottom += insets.bottom
        self.left += insets.left
        self.right += insets.right
    }
    
    var ca_horizontalInset: CGFloat {
        return self.right + self.left
    }
    
    var ca_verticalInset: CGFloat {
        return self.bottom + self.top
    }
}

extension CGSize {
    init(ca_size size: CGFloat) {
        self.init(width: size, height: size)
    }
}

extension CGRect {
    func ca_center() -> CGPoint {
        return CGPoint(x: self.width / 2.0, y: self.height / 2.0)
    }
}
