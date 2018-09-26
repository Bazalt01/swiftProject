//
//  CompositeDataSource.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 01/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class CompositeDataSource: BaseCollectionDataSource {
    
    var dataSources = [BaseCollectionDataSource]() {
        didSet {
            var classes = [BaseCollectionViewCell.Type]()
            for dataSource in dataSources {
                classes.append(contentsOf: dataSource.cellClasses)
            }
            cellClasses = classes
        }
    }
    
    override var sections: [Array<CellViewModel>] {
        get {
            var sections = [Array<CellViewModel>]()
            for dataSource in dataSources {
                sections.append(contentsOf: dataSource.sections)
            }
            sections.append(self.cellViewModels)
            return sections
        }
    }
}
