//
//  SeparatorView.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 25/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

enum SeparatorType {
    case general    
}

class SeparatorView: UIView {
    let type: SeparatorType
    
    init(type: SeparatorType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        self.type = .general
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.type = .general
        super.init(coder: aDecoder)
    }
}
