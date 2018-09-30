//
//  TemplateShareCollectionDelegate.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 27/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class TemplateShareCollectionDelegate: BaseCollectionViewDelegate {
    
    // MARK: - Inits
    
    init(dataSource: BaseCollectionDataSource) {
        let lm = LayoutManager(viewsByClass: [TemplateShareCell.ca_reuseIdentifier(): TemplateShareCell(),
                                              TemplateShareHeaderView.ca_reuseIdentifier(): TemplateShareHeaderView()])
        super.init(layoutManager: lm, dataSource: dataSource)
    }
}
