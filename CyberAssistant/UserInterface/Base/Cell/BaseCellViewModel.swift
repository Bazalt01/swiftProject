//
//  BaseCellViewModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 13/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class BaseCellViewModel: CellViewModel {
    private(set) var cellClass: BaseCollectionViewCell.Type    
    var layoutModel = CellLayoutModel(size: CGSize.zero)
    var isCalculatingSize: Bool = false
    
    required init(cellClass: BaseCollectionViewCell.Type) {
        self.cellClass = cellClass
    }
}
