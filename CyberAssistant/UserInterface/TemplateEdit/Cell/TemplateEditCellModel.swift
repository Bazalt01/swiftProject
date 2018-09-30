//
//  TemplateEditCellModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift

class TemplateEditCellModel: BaseCellViewModel {
    private(set) var templateAttrText = NSAttributedString()
    
    // MARK: - Inits
    
    convenience init() {
        self.init(viewClass: TemplateEditCell.self)
    }
    
    required init(viewClass: (UIView & View).Type) {
        super.init(viewClass: viewClass)
    }
    
    // MARK: - Public
    
    func update(template: NSAttributedString) {
        if template.isEqual(to: templateAttrText) {
            return
        }
        
        let attributes = [NSAttributedStringKey.foregroundColor : AppearanceColor.textView, NSAttributedStringKey.font : AppearanceFont.textView]
        let attrText = NSMutableAttributedString(string: template.string, attributes: attributes)
        templateAttrText = TemplateFormatter.format(attrTemplate: attrText)
    }
}
