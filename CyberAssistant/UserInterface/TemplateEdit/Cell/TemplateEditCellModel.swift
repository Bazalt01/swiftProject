//
//  TemplateEditCellModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class TemplateEditCellModel: BaseCellViewModel {
    private(set) var template = ""
    
    // MARK: - Inits
    
    convenience init() {
        self.init(viewClass: TemplateEditCell.self)
    }
    
    required init(viewClass: (UIView & View).Type) {
        super.init(viewClass: viewClass)
    }
    
    // MARK: - Public
    
    func update(template: String?) {
        guard
            template != nil,
            template != self.template else {
            return
        }
        self.template = template!
    }
}
