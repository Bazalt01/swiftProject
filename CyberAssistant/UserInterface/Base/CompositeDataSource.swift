//
//  CompositeDataSource.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 01/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class CompositeDataSource<T: DataSource>: DataSource {
    private(set) var dataSources: [T] = []
    
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
    
    // MARK: - Public
    
    func add(dataSource: T) {
        insert(dataSource: dataSource, index: dataSources.count)
    }
    
    func insert(dataSource: T, index: Int) {
        dataSource.collectionView = collectionView
        dataSource.tableView = tableView
        dataSources.insert(dataSource, at: index)
        updateSectionNumber()
    }
    
    func remove(atIndex index: Int) {
        let dataSource = dataSources[index]
        dataSource.collectionView = nil
        dataSources.remove(at: index)
        updateSectionNumber()
    }
    
    override func numberOfSections() -> Int {
        var numberOfSections = 0
        for dataSource in dataSources {
            numberOfSections += dataSource.numberOfSections()
        }
        return numberOfSections
    }
    
    override func numberOfItems(inSection section: Int) -> Int {
        let map = sectionMap()
        guard section < map.count else {
            print("[CompositeDataSource] Error: Attempt get numberOfItems for invalid section")
            assertionFailure()
            return 0
        }
        let globalIndex = map[section]
        let dataSource = dataSources[globalIndex]
        let localSection = dataSource.numberOfSections() > 1 ? section - globalIndex : 0
        return dataSource.numberOfItems(inSection: localSection)
    }

    override func model(atIndexPath indexPath: IndexPath) -> ViewModel? {
        let map = sectionMap()
        guard indexPath.section < map.count else {
            print("[CompositeDataSource] Error: Attempt get model for invalid section number")
            assertionFailure()
            return nil
        }
        let globalIndex = map[indexPath.section]
        let dataSource = dataSources[globalIndex]
        let localSection = dataSource.numberOfSections() > 1 ? indexPath.section - globalIndex : 0
        let indexPath = IndexPath(item: indexPath.item, section: localSection)
        return dataSource.model(atIndexPath: indexPath)
    }
    
    override func supplementaryModel(atSection section: Int, kind: SupplementaryViewKind) -> ViewModel? {
        let map = sectionMap()
        guard section < map.count else {
            print("[CompositeDataSource] Error: Attempt get supplementaryModel for invalid section")
            assertionFailure()
            return nil
        }
        let globalIndex = map[section]
        let dataSource = dataSources[globalIndex]
        let localSection = dataSource.numberOfSections() > 1 ? section - globalIndex : 0
        return dataSource.supplementaryModel(atSection: localSection, kind: kind)
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let map = sectionMap()
        guard section < map.count else {            
            assertionFailure()
            return nil
        }
        let globalIndex = map[section]
        let dataSource = dataSources[globalIndex]
        let localSection = dataSource.numberOfSections() > 1 ? section - globalIndex : 0
        return dataSource.tableView(tableView, titleForHeaderInSection: localSection)
    }
    
    // MARK: - Private
    
    private func updateSectionNumber() {
        var sectionIndex = section
        for dataSource in dataSources {
            dataSource.section = sectionIndex
            sectionIndex += dataSource.numberOfSections()
        }
    }
    
    private func sectionMap() -> [Int] {
        var localForGlobalSections: [Int] = []
        for globalIndex in 0..<dataSources.count {
            let dataSource = dataSources[globalIndex]
            let innerSectionCount = dataSource.numberOfSections()
            for _ in 0..<innerSectionCount {
                localForGlobalSections.append(globalIndex)
            }
        }
        return localForGlobalSections
    }
}
