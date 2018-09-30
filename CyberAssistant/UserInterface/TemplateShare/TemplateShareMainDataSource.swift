//
//  TemplateShareMainDataSource.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 28/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import RxSwift

struct SectionMap {
    var section: Int
    var indexes: [Int]
}

class TemplateShareMainDataSource: CompositeDataSource {
    private(set) var dataSourcesByKey = [String : TemplateShareDataSource]()
    private(set) var sectionMaps = [String : [Int]]()
    
    let saveObserver = PublishSubject<SharedTemplateModel>()
    
    // MARK: - Public
    
    override func add(dataSource: BaseCollectionDataSource) {
        super.add(dataSource: dataSource)
        dataSourcesByKey[dataSource.key!] = dataSource as? TemplateShareDataSource
    }
    
    override func insert(dataSource: BaseCollectionDataSource, index: Int) {
        super.insert(dataSource: dataSource, index: index)
        dataSourcesByKey[dataSource.key!] = dataSource as? TemplateShareDataSource
    }
    
    override func remove(atIndex index: Int) {
        dataSourcesByKey.removeValue(forKey: dataSources[index].key!)
        super.remove(atIndex: index)
    }
    
    override func notifyUpdate(batchUpdates: [BatchUpdate]?, completion: (() -> Void)?) {
        updateSectionMaps()
        super.notifyUpdate(batchUpdates: batchUpdates, completion: completion)
    }
    
    func insert(indexes: [Int], templates: [SharedTemplateModel]) {
        guard indexes.count > 0 else {
            return
        }
        
        var sections = [Int]()
        var indexPaths = [IndexPath]()
        let sectionByKey = updatedSectionsByKey(templates: templates)
        
        for index in indexes {
            let template = templates[index]
            guard let author = template.author else {
                continue
            }
            if let dataSource = dataSourcesByKey[author.name] {
                dataSource.insert(template: template, index: index, needNotify: false, observer: saveObserver)
                
                let section = dataSources.firstIndex(of: dataSource)!
                indexPaths.append(IndexPath(item: index, section: section))
            }
            else {
                let dataSource = TemplateShareDataSource(title: author.name)
                dataSource.add(template: template, needNotify: false, observer: saveObserver)
                
                let section = sectionByKey[author.name]!.section
                sections.append(section)
                indexPaths.append(IndexPath(item: 0, section: section))
                insert(dataSource: dataSource, index: section)
            }
        }
        
        let batchUpdate = BatchUpdate(option: .insert, indexPathes: indexPaths, sections: IndexSet(sections))
        notifyUpdate(batchUpdates: [batchUpdate], completion: nil)
    }
    
    func remove(indexes: [Int]) {
        guard indexes.count > 0 else {
            return
        }
        
        let sortIndexes = indexes.sorted { (i1, i2) -> Bool in
            return i1 > i2
        }
        
        var sections = [Int]()
        var indexPaths = [IndexPath]()
        
        var tempMaps = sectionMaps
        for index in sortIndexes {
            for key in tempMaps.keys {
                let indexes = tempMaps[key]!
                guard indexes.contains(index) else {
                    tempMaps.removeValue(forKey: key)
                    continue
                }
                let dataSource = dataSourcesByKey[key]!
                let localIndex = indexes.firstIndex(of: index)!
                dataSource.remove(atIndex: localIndex)
                
                let section = dataSources.firstIndex(of: dataSource)!
                if dataSource.cellViewModels.count == 0 {
                    sections.append(section)
                    remove(atIndex: section)
                }
                
                indexPaths.append(IndexPath(item: localIndex, section: section))
                break
            }
        }
        
        let batchUpdate = BatchUpdate(option: .delete, indexPathes: indexPaths, sections: IndexSet(sections))
        notifyUpdate(batchUpdates: [batchUpdate], completion: nil)
    }
    
    func update(indexes: [Int], templates: [SharedTemplateModel]) {
        guard indexes.count > 0 else {
            return
        }
        
        var indexPaths = [IndexPath]()
        for index in indexes {
            for key in sectionMaps.keys {
                let globalIndexes = sectionMaps[key]!
                guard globalIndexes.contains(index) else {
                    continue
                }
                let dataSource = dataSourcesByKey[key]!
                
                let localIndex = indexes.firstIndex(of: index)!
                dataSource.remove(atIndex: localIndex)
                dataSource.insert(template: templates[index], index: localIndex, needNotify: false, observer: saveObserver)
                
                let section = dataSources.firstIndex(of: dataSource)!
                indexPaths.append(IndexPath(item: localIndex, section: section))
                break
            }
        }
        
        let batchUpdate = BatchUpdate(option: .update, indexPathes: indexPaths, sections: IndexSet())
        notifyUpdate(batchUpdates: [batchUpdate], completion: nil)
    }
    
    // MARK: - Private
    
    private func updatedSectionsByKey(templates: [SharedTemplateModel]) -> [String : SectionMap] {
        guard templates.count > 0 else {
            return [:]
        }
        
        var sectionMaps = [String : SectionMap]()
        var lastKey = templates.first!.author!.name
        var indexes = [Int]()
        templates.enumerated().forEach { (offset, template) in
            if lastKey != template.author!.name {
                sectionMaps[lastKey] = SectionMap(section: sectionMaps.count, indexes: indexes)
                lastKey = template.author!.name
                indexes = []
            }
            indexes.append(offset)
            if offset == templates.count - 1 {
                sectionMaps[lastKey] = SectionMap(section: sectionMaps.count, indexes: indexes)
                lastKey = template.author!.name
            }
        }
        
        return sectionMaps
    }
    
    private func updateSectionMaps() {
        var sectionMaps = [String : [Int]]()
        var globalIndex = 0
        dataSources.enumerated().forEach { (offset, dataSource) in
            let count = dataSource.cellViewModels.count
            guard let key = dataSource.key, count > 0 else {
                return
            }
            
            let globalIndexes = Array(globalIndex..<dataSource.cellViewModels.count + globalIndex)
            sectionMaps[key] = globalIndexes
            globalIndex += count
        }
        self.sectionMaps = sectionMaps
    }
}
