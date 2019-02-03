//
//  TemplateCollectionDelegate.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 15/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class TemplateCollectionDelegate: CollectionViewDelegate {
    
    // MARK: - Inits
    
    init(dataSource: DataSource) {
        let lm = LayoutManager(viewsByClass: [TemplateCell.ca_reuseIdentifier(): TemplateCell()])
        super.init(layoutManager: lm, dataSource: dataSource)
    }
}
