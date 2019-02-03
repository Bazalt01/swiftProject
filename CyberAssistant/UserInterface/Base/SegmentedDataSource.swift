//
//  SegmentedDataSource.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 04/02/2019.
//  Copyright © 2019 g.tokmakov. All rights reserved.
//

import UIKit

class SegmentedDataSource<T: DataSource>: DataSource {
    private(set) var dataSources: [T] = []
    var selectedIndex: Int = 0 {
        didSet {
            notifyUpdate()
        }
    }
    
    override weak var collectionView: UICollectionView? {
        didSet {
            dataSources.forEach { $0.collectionView = collectionView }
        }
    }
    override weak var tableView: UITableView? {
        didSet {
            dataSources.forEach { $0.tableView = tableView }
        }
    }
    
    func add(dataSource: T) {
        insert(dataSource: dataSource, index: dataSources.count)
    }
    
    func insert(dataSource: T, index: Int) {
        dataSource.collectionView = collectionView
        dataSource.tableView = tableView
        dataSources.insert(dataSource, at: index)
    }
    
    func remove(atIndex index: Int) {
        let dataSource = dataSources[index]
        dataSource.collectionView = nil
        dataSources.remove(at: index)
    }
    
    override func numberOfSections() -> Int {
        return dataSources[selectedIndex].numberOfSections()
    }
    
    override func numberOfItems(inSection section: Int) -> Int {
        return dataSources[selectedIndex].numberOfItems(inSection: section)
    }
    
    override func model(atIndexPath indexPath: IndexPath) -> ViewModel? {
        return dataSources[selectedIndex].model(atIndexPath: indexPath)
    }
    
    override func index(forItem item: ViewModel) -> IndexPath? {
        return dataSources[selectedIndex].index(forItem: item)
    }
    
    override func supplementaryModel(atSection section: Int, kind: SupplementaryViewKind) -> ViewModel? {
        return dataSources[selectedIndex].supplementaryModel(atSection: section, kind: kind)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSources[selectedIndex].tableView(tableView, titleForHeaderInSection: section)
    }
}
