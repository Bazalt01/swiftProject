//
//  TemplateEditRuleCellModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class TemplateEditRuleCellModel: BaseCellViewModel {
    private(set) var rule: NSAttributedString
    private(set) var example: NSAttributedString
    private(set) var result: NSAttributedString
    
    private var templateRule: TemplateRule
    
    // MARK: - Inits
    
    required init(rule: TemplateRule) {
        self.templateRule = rule
        self.rule = TemplateFormatter.format(template: rule.rule)
        self.example = TemplateFormatter.format(template: rule.example)
        self.result = TemplateFormatter.format(template: rule.result)
        super.init(viewClass: TemplateEditRuleCell.self)
    }
    
    required init(viewClass: (UIView & View).Type) {
        assert(false)
        self.templateRule = TemplateRule(rule: "", example: "", result: "")
        self.rule = NSAttributedString(string: "")
        self.example = NSAttributedString(string: "")
        self.result = NSAttributedString(string: "")
        super.init(viewClass: viewClass)
    }
}
