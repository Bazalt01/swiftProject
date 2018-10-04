//
//  TemplateEditCollectionDelegate.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class TemplateEditCollectionDelegate: BaseCollectionViewDelegate {
    
    // MARK: - Inits
    
    init(dataSource: BaseCollectionDataSource) {
        let lm = LayoutManager(viewsByClass: [TemplateEditCell.ca_reuseIdentifier(): TemplateEditCell(),
                                              HeaderView.ca_reuseIdentifier(): HeaderView(),
                                              TemplateEditRuleCell.ca_reuseIdentifier(): TemplateEditRuleCell()])
        super.init(layoutManager: lm, dataSource: dataSource)
    }
    
    // MARK: - Public
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.endEditing(true)
    }
}
