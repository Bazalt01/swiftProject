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
    
    // MARK: - Public
    
    func add(dataSource: T) {
        insert(dataSource: dataSource, index: dataSources.count)
    }
    
    func insert(dataSource: T, index: Int) {
        dataSource.collectionView = collectionView
        dataSources.insert(dataSource, at: index)
    }
    
    func remove(atIndex index: Int) {
        dataSources.remove(at: index)
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
    
    // MARK: - Private
    
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
