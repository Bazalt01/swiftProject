//
//  TemplateEditRulesDataSource.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 01/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class TemplateEditRulesDataSource: BaseDataSource {
    
    override init() {
        super.init()
        self.cellClasses = [TemplateEditRuleCell.self]
    }
    
    func configureAndSetCellViewModel(rules: [TemplateRule], labelAnimator: LabelAnimator?) {
        var viewModels = [TemplateEditRuleCellModel]()
        for rule in rules {
            let cellViewModel = TemplateEditRuleCellModel(rule: rule, labelAnimator: labelAnimator)
            viewModels.append(cellViewModel)
        }
        cellViewModels = viewModels
        notifyUpdate(batchUpdates: nil, completion: nil)
    }
}
