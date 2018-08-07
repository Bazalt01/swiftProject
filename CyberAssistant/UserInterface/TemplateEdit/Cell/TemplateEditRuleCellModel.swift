//
//  TemplateEditRuleCellModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class TemplateEditRuleCellModel: BaseCellViewModel {
    private(set) var rule: NSAttributedString
    private(set) var example: NSAttributedString
    private(set) var result: NSAttributedString
    
    private var templateRule: TemplateRule
    private var animator: LabelAnimator?
    var labelAnimator: LabelAnimator? {
        get {
            return isCalculatingSize ? nil : animator
        }
        set(value) {
            self.animator = value
        }
    }
    
    required init(rule: TemplateRule, labelAnimator: LabelAnimator?) {
        self.templateRule = rule
        self.rule = TemplateFormatter.format(template: rule.rule)
        self.example = TemplateFormatter.format(template: rule.example)
        self.result = TemplateFormatter.format(template: rule.result)
        self.animator = labelAnimator
        super.init(cellClass: TemplateEditRuleCell.self)
    }
    required init(cellClass: BaseCollectionViewCell.Type) {
        assert(false)
        self.templateRule = TemplateRule(rule: "", example: "", result: "")
        self.animator = LabelAnimator(stepDuration: 1.0)
        self.rule = NSAttributedString(string: "")
        self.example = NSAttributedString(string: "")
        self.result = NSAttributedString(string: "")
        super.init(cellClass: cellClass)
    }
}
