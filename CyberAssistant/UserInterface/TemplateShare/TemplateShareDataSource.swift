//
//  TemplateShareDataSource.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 27/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift

class TemplateShareDataSource: DataSource {
    private var shareCellViewModels: [TemplateShareCellModel] = []
    override var cellViewModels: [ViewModel] {
        didSet {
            shareCellViewModels = cellViewModels as! [TemplateShareCellModel]
        }
    }
    
    init(title: String) {        
        super.init()
        self.key = title
        self.title = title
        self.cellClasses = [TemplateShareCell.self]
        self.supplementaryViewClasses = [(classType: HeaderView.self, kind: .header)]
        self.supplementaryViewHeaderModel = HeaderViewModel(title: title)
    }
    
    // MARK: - Public
    
    func add(template: SharedTemplateModel, needNotify: Bool, observable: PublishSubject<SharedTemplateModel>) {
        insert(template: template, index: cellViewModels.count, needNotify: needNotify, observable: observable)
    }
    
    func insert(template: SharedTemplateModel, index: Int, needNotify: Bool, observable: PublishSubject<SharedTemplateModel>) {
        let cellViewModel = TemplateShareCellModel(template: template, didSave: observable)
        cellViewModels.insert(cellViewModel, at: index)
        if needNotify {
            notify(batchUpdates: nil, completion: nil)
        }
    }
    
    func remove(atIndex index: Int) {
        cellViewModels.remove(at: index)
    }
}
