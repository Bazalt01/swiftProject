//
//  SeparatorView.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 25/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

enum SeparatorType {
    case general    
}

class SeparatorView: UIView {
    private(set) var type: SeparatorType = .general
    
    init(type: SeparatorType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
