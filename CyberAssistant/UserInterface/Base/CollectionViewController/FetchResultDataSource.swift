//
//  FetchResultDataSource.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 04/02/2019.
//  Copyright © 2019 g.tokmakov. All rights reserved.
//

import UIKit

class FetchResultDataSource<T: DataSource, U>: DataSource {
    private let throller = Throttler(minimumDelay: 0.5)
    private let filterBlock: (_ viewModel: ViewModel, _ value: U) -> Bool
    private var filteredIndexes: [Int]?
    private var originalCellViewModels: [ViewModel] = []
    var isFiltered: Bool {
        return filteredIndexes != nil
    }
    
    init(filterBlock: @escaping (_ viewModel: ViewModel, _ value: U) -> Bool) {
        self.filterBlock = filterBlock
    }
    
    func filter(value: U?) {
        guard isFiltered || value != nil else { return }
        
        if originalCellViewModels.count == 0 {
            originalCellViewModels = cellViewModels
        }
        
        var resultIndexes: [Int] = []
        let result = originalCellViewModels.enumerated().filter { index, element -> Bool in
            guard let value = value else {
                resultIndexes = Array(0..<originalCellViewModels.count)
                return true
            }
            let isAllow = filterBlock(element, value)
            if isAllow {
                resultIndexes.append(index)
            }
            return isAllow
        }
        
        cellViewModels = result.map { $0.element }
        
        var batchUpdates: [BatchUpdate]?
        if let filteredIndexes = filteredIndexes {
            batchUpdates = buildBatchUpdates(new: resultIndexes, old: filteredIndexes)
        } else {
            batchUpdates = buildBatchUpdates(new: resultIndexes, old: Array(0..<originalCellViewModels.count))
        }
        filteredIndexes = resultIndexes
        
        if value == nil {
            filteredIndexes = nil
            originalCellViewModels = []
        }
        
        if let batchUpdates = batchUpdates {
            notify(batchUpdates: batchUpdates, completion: nil)
        }
    }
    
    private func buildBatchUpdates(new: [Int], old: [Int]) -> [BatchUpdate]? {
        guard new != old else {
            return nil
        }
        
        let newSet = Set(new)
        let oldSet = Set(old)
        let diff = newSet.subtracting(oldSet).union(oldSet.subtracting(newSet))
        
        var deletedIndexes: [IndexPath] = []
        var insertedIndexes: [IndexPath] = []
        if diff.count == 0 {
            deletedIndexes = old.map { IndexPath(item: $0, section: 0) }
            insertedIndexes = new.map { IndexPath(item: $0, section: 0) }
        } else {
            diff.forEach { value in
                if let index = old.firstIndex(of: value) {
                    deletedIndexes.append(IndexPath(item: index, section: 0))
                }
                if let index = new.firstIndex(of: value) {
                    insertedIndexes.append(IndexPath(item: index, section: 0))
                }
            }
        }
        
        let batchForDeleting = BatchUpdate(option: .delete, indexPathes: deletedIndexes, sections: nil)
        let batchForInserting = BatchUpdate(option: .insert, indexPathes: insertedIndexes, sections: nil)
        return [batchForDeleting, batchForInserting]
    }
}

