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
    
    private let didActionSubject = PublishSubject<(TemplateModel, CellActionType)>()
    
    var didActionTemplate: Observable<(TemplateModel, CellActionType)> {
        return didActionSubject.share()
    }
    
    // MARK: - Public
    
    func configureAndSetCellViewModel(templateModels: [TemplateModel], batchUpdates: [BatchUpdate]?) {
        cellViewModels = templateModels.map { configuredCellViewModel(template: $0) }
        notify(batchUpdates: batchUpdates, completion: nil)
    }
    
    func configuredCellViewModel(template: TemplateModel) -> TemplateCellModel {
        let cellVM = TemplateCellModel(template: template)
        cellVM.actionBlock = { [weak self] in
            guard let `self` = self else { return }
            self.didActionSubject.onNext((template, $0)) }
        return cellVM
    }
    
    func template(byCellModel cellModel: ViewModel) -> TemplateModel? {
        if cellModel is TemplateCellModel {
            return (cellModel as! TemplateCellModel).template
        }
        return nil
    }
}
