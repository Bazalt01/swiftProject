//
//  TemplateEditRulesDataSource.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 01/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class TemplateEditRulesDataSource: BaseCollectionDataSource {
    
    // MARK: - Inits
    
    override init() {
        super.init()
        self.cellClasses = [TemplateEditRuleCell.self]
        self.supplementaryViewClasses = [(classType: HeaderView.self, kind: .header)]
        self.supplementaryViewHeaderModel = HeaderViewModel(title: NSLocalizedString("examples", comment: ""))
    }
    
    // MARK: - Public
    
    func configureAndSetCellViewModel(rules: [TemplateRule]) {
        cellViewModels = rules.map { TemplateEditRuleCellModel(rule: $0) }
        notify(batchUpdates: nil, completion: nil)
    }
}
