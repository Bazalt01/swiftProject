//
//  TemplateShareDataSource.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 27/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift

class TemplateShareDataSource: BaseCollectionDataSource {
    private var shareCellViewModels = [TemplateShareCellModel]()
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
        self.supplementaryViewClasses = [(classType: TemplateShareHeaderView.self, kind: .header)]
        self.supplementaryViewHeaderModel = TemplateShareHeaderViewModel(title: title)
    }
    
    // MARK: - Public
    
    func add(template: SharedTemplateModel, needNotify: Bool, observer: PublishSubject<SharedTemplateModel>) {
        insert(template: template, index: cellViewModels.count, needNotify: needNotify, observer: observer)
    }
    
    func insert(template: SharedTemplateModel, index: Int, needNotify: Bool, observer: PublishSubject<SharedTemplateModel>) {
        let cellViewModel = TemplateShareCellModel(template: template, observer: observer)
        cellViewModels.insert(cellViewModel, at: index)
        if needNotify {
            notifyUpdate(batchUpdates: nil, completion: nil)
        }
    }
    
    func remove(atIndex index: Int) {
        cellViewModels.remove(at: index)
    }
}
