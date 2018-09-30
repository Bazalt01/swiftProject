//
//  CompositeDataSource.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 01/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class CompositeDataSource: BaseCollectionDataSource {
    private(set) var dataSources = [BaseCollectionDataSource]()        
    
    // MARK: - Public
    
    func add(dataSource: BaseCollectionDataSource) {
        insert(dataSource: dataSource, index: dataSources.count)
    }
    
    func insert(dataSource: BaseCollectionDataSource, index: Int) {
        dataSources.insert(dataSource, at: index)
        
        cellClasses.append(contentsOf: dataSource.cellClasses)
        supplementaryViewClasses.append(contentsOf: dataSource.supplementaryViewClasses)
    }
    
    func remove(atIndex index: Int) {
        dataSources.remove(at: index)
    }
    
    override func numberOfSections() -> Int {
        return dataSources.count
    }
    
    override func numberOfItems(inSection section: Int) -> Int {
        return dataSources[section].cellViewModels.count
    }

    override func model(atIndexPath indexPath: IndexPath) -> ViewModel? {
        return dataSources[indexPath.section].cellViewModels[indexPath.item]
    }
    
    override func index(forItem item: ViewModel) -> IndexPath? {
        for section in 0..<dataSources.count {
            let dataSource = dataSources[section]
            if let indexPath = dataSource.index(forItem: item) {
                return IndexPath(item: indexPath.item, section: section)
            }
        }
        return nil
    }
    
    // MARK: - Private
    
    override func supplementaryModel(atSection section: Int, kind: SupplementaryViewKind) -> ViewModel? {
        let dataSource = dataSources[section]
        return kind == .header ? dataSource.supplementaryViewHeaderModel : dataSource.supplementaryViewFooterModel
    }
}
