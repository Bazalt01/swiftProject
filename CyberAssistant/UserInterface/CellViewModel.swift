//
//  CellViewModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

protocol CellViewModel {
    var cellClass: BaseCollectionViewCell.Type { get }
    var layoutModel: CellLayoutModel { get set }
    var isCalculatingSize: Bool { get set }
    
    init(cellClass: BaseCollectionViewCell.Type)
}
