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
    
    let deleteTemplateObserver = PublishSubject<TemplateModel>()
    let muteTemplateObserver = PublishSubject<TemplateModel>()
    
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
        cellVM.deleteBlock = { [weak self]() in
            self?.deleteTemplateObserver.onNext(template)
        }
        cellVM.muteBlock = { [weak self]() in
            self?.muteTemplateObserver.onNext(template)
        }
        return cellVM
    }
    
    func template(byCellModel cellModel: CellViewModel) -> TemplateModel? {
        if cellModel is TemplateCellModel {
            return (cellModel as! TemplateCellModel).template
        }
        return nil
    }
}
