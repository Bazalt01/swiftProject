//
//  UIView+Utils.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 28/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

extension UIView {
    func ca_configuredFittingSize(size: CGSize) -> CGSize {
        let width = size.width - layoutMargins.ca_horizontalInset
        let height = CGFloat.greatestFiniteMagnitude
        return CGSize(width: width, height: height)
    }
}
