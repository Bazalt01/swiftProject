//
//  TemplateCollectinoDataSource.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 13/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import RxSwift

class TemplateCollectionDataSource: BaseCollectionDataSource {
    
    // MARK: - Inits
    
    override init() {
        super.init()
        self.cellClasses = [TemplateCell.self]
    }
    
    let didDeleteTemplate = PublishSubject<TemplateModel>()
    let didMuteTemplate = PublishSubject<TemplateModel>()
    let didShareTemplate = PublishSubject<TemplateModel>()
    
    // MARK: - Public
    
    func configureAndSetCellViewModel(templateModels: [TemplateModel], batchUpdates: [BatchUpdate]?) {
        var viewModels = [TemplateCellModel]()
        for template in templateModels {
            let cellVM = configuredCellViewModel(template: template)
            viewModels.append(cellVM)
        }
        
        cellViewModels = viewModels
        notifyUpdate(batchUpdates: batchUpdates, completion: nil)
    }
    
    func configuredCellViewModel(template: TemplateModel) -> TemplateCellModel {
        let cellVM = TemplateCellModel(template: template)
        cellVM.deleteBlock = { [weak self] in
            self?.didDeleteTemplate.onNext(template)
        }
        cellVM.muteBlock = { [weak self] in
            self?.didMuteTemplate.onNext(template)
        }
        cellVM.shareBlock = { [weak self] in
            self?.didShareTemplate.onNext(template)
        }
        return cellVM
    }
    
    func template(byCellModel cellModel: ViewModel) -> TemplateModel? {
        if cellModel is TemplateCellModel {
            return (cellModel as! TemplateCellModel).template
        }
        return nil
    }
}
