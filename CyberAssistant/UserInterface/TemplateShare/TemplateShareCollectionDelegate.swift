//
//  TemplateShareCollectionDelegate.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 27/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class TemplateShareCollectionDelegate: CollectionViewDelegate {
    
    // MARK: - Inits
    
    init(dataSource: DataSource) {
        let lm = LayoutManager(viewsByClass: [TemplateShareCell.ca_reuseIdentifier(): TemplateShareCell(),
                                              HeaderView.ca_reuseIdentifier(): HeaderView()])
        super.init(layoutManager: lm, dataSource: dataSource)
    }
}
