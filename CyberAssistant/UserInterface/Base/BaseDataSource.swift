//
//  BaseDataSource.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

enum SupplementaryViewKind: String {
    case header = "Header"
    case footer = "Footer"
}

struct BatchUpdate {
    private(set) var option: BatchOption
    private(set) var indexes: [Int]
    private(set) var section: Int
}

typealias SupplementaryViewClassWithKind = (classType: UICollectionReusableView.Type, kind: SupplementaryViewKind)

class BaseDataSource: NSObject {
    var cellClasses = [BaseCollectionViewCell.Type]()
    var supplementaryViewClasses: [SupplementaryViewClassWithKind]?
    weak var collectionView: UICollectionView? {
        didSet {
            if let cv = collectionView {
                registerReusableViewsWithCollectionView(collectionView: cv)
            }
        }
    }
    
    var sections: [Array<CellViewModel>] {
        get {
            return [cellViewModels]
        }
    }
    
    var cellViewModels = Array<CellViewModel>()
    
    func registerReusableViewsWithCollectionView(collectionView: UICollectionView) {
        for cellClass in cellClasses {
            collectionView.register(cellClass, forCellWithReuseIdentifier: cellClass.ca_reuseIdentifier())
        }
        
        if let classes = supplementaryViewClasses {
            for supplementaryViewClass in classes {
                let classType = supplementaryViewClass.classType
                let kind = supplementaryViewClass.kind
                collectionView.register(classType, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: classType.ca_reuseIdentifier())
            }
        }
    }
    
    func modelAtIndexPath(indexPath: IndexPath) -> CellViewModel? {
        assert(sections.count > 0)
        return sections[indexPath.section][indexPath.item]
    }
    
    private func notifyUpdate() {
        if let cv = collectionView {
            cv.reloadData()
        }
    }
    
    func notifyUpdate(batchUpdates: [BatchUpdate]?, completion: (() -> Void)?) {
        guard let cv = collectionView else {
            return
        }
        
        if batchUpdates == nil {
            notifyUpdate()
        }
        else {
            cv.performBatchUpdates({
                self.performBatchUpdates(collectionView: cv, batchUpdates: batchUpdates!)
            }) { (finish) in
                if let compl = completion {
                    compl()
                }
            }
        }
    }
    
    private func performBatchUpdates(collectionView: UICollectionView, batchUpdates: [BatchUpdate]) {
        for batch in batchUpdates {
            let indexPaths = createIndexPath(batchUpdate: batch)
            switch batch.option {
            case .delete:
                collectionView.deleteItems(at: indexPaths)
                break
            case .insert:
                collectionView.insertItems(at: indexPaths)
                break
            case .update:
                collectionView.reloadItems(at: indexPaths)
            }
        }
    }
    
    private func createIndexPath(batchUpdate: BatchUpdate) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for index in batchUpdate.indexes {
            indexPaths.append(IndexPath(item: index, section: batchUpdate.section))
        }
        return indexPaths
    }
}

extension BaseDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        assert(sections.count > 0)
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assert(sections.count > 0)
        return sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModel = modelAtIndexPath(indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        let reuseIdentifier = cellViewModel.cellClass.ca_reuseIdentifier()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BaseCollectionViewCell
        cell.viewModel = cellViewModel
        return cell
    }
}
