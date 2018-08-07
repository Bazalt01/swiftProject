//
//  TemplateCollectionDelegate.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 15/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class TemplateCollectionDelegate: BaseCollectionViewDelegate {
    init(dataSource: BaseDataSource) {
        let lm = BaseCellLayoutManager(cellsByClass: [TemplateCell.className(): TemplateCell()])
        super.init(cellLayoutManager: lm, dataSource: dataSource)
    }
}
