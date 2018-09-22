//
//  CellLayoutManager.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

typealias CellClass = String

class BaseCellLayoutManager {
    private var cellsByClass: [CellClass: BaseCollectionViewCell]
    
    // MARK: - Inits
    
    init(cellsByClass: [CellClass: BaseCollectionViewCell]) {
        self.cellsByClass = cellsByClass
    }
    
    // MARK: - Public
    
    func updateLayoutModel(cellViewModel: inout CellViewModel, size: CGSize) {
        let className = NSStringFromClass(cellViewModel.cellClass.self)
        guard let cell = cellsByClass[className] else {
            return
        }
        
        if cellViewModel.layoutModel.size.width == size.width {
            return
        }
        cellViewModel.isCalculatingSize = true
        cell.viewModel = cellViewModel
        cellViewModel.layoutModel = CellLayoutModel(size: cell.sizeThatFits(size))
        cellViewModel.isCalculatingSize = false
    }
}
