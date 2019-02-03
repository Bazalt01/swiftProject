//
//  TemplateEditDataSource.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class TemplateEditDataSource: DataSource {
    var templateString: String? {
        return templateEditCellModel?.template
    }
    private var templateEditCellModel: TemplateEditCellModel?
    
    // MARK: - Inits
    
    override init() {
        super.init()
        self.cellClasses = [TemplateEditCell.self]
    }
    
    // MARK: - Public
    
    func configureAndSetCellViewModel(template: String) {
        templateEditCellModel = TemplateEditCellModel()
        templateEditCellModel!.update(template: template)
        cellViewModels = [templateEditCellModel!]
        notify(batchUpdates: nil, completion: nil)
    }        
}
