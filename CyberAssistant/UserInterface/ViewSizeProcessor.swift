//
//  ViewSizeProcessor.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 02/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class ViewSizeProcessor {
    class func calculateSize(label: UILabel, fittingSize: CGSize) -> CGSize {
        let attr = NSAttributedString(string: label.text!, attributes: [NSAttributedStringKey.font : label.font])
        return attr.boundingRect(with: fittingSize, options: fittingOptions, context: nil).size
    }
}

