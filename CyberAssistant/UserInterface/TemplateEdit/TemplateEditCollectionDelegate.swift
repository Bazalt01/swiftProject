//
//  TemplateEditCollectionDelegate.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class TemplateEditCollectionDelegate: BaseCollectionViewDelegate {
    init(dataSource: BaseDataSource) {
        let lm = BaseCellLayoutManager(cellsByClass: [TemplateEditCell.className(): TemplateEditCell(),
                                                      TemplateEditRuleCell.className(): TemplateEditRuleCell()])
        super.init(cellLayoutManager: lm, dataSource: dataSource)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.endEditing(true)
    }
}
