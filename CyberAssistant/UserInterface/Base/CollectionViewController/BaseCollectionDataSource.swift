//
//  BaseCollectionDataSource.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import RxSwift

enum SupplementaryViewKind: String {
    case header = "UICollectionElementKindSectionHeader"
    case footer = "UICollectionElementKindSectionFooter"
}

struct BatchUpdate {
    private(set) var option: BatchOption
    private(set) var indexPathes: [IndexPath]
    private(set) var sections: IndexSet
    init(option: BatchOption, indexPathes: [IndexPath], sections: IndexSet) {
        self.option = option
        self.indexPathes = indexPathes
        self.sections = sections
    }
}

typealias SupplementaryViewClassWithKind = (classType: BaseSupplementaryView.Type, kind: SupplementaryViewKind)

class BaseCollectionDataSource: NSObject {
    var key: String?
    var title: String?
    var cellClasses: [BaseCollectionViewCell.Type] = [] {
        didSet {
            guard let cv = collectionView else { return }
            register(cellClasses: cellClasses, collectionView: cv)
        }
    }
    var supplementaryViewClasses: [SupplementaryViewClassWithKind] = [] {
        didSet {
            guard let cv = collectionView else { return }
            register(supplementaryViewClasses: supplementaryViewClasses, collectionView: cv)
        }
    }
    weak var collectionView: UICollectionView? {
        didSet {
            guard let cv = collectionView else { return }
            register(cellClasses: cellClasses, collectionView: cv)
            register(supplementaryViewClasses: supplementaryViewClasses, collectionView: cv)
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func index(forItem item: ViewModel) -> IndexPath? {
        guard let index = cellViewModels.firstIndex(where: { item.isEqual(viewModel: $0) }) else { return nil }
        return IndexPath(item: index, section: 0)
    }
    
    var cellViewModels = Array<ViewModel>()
    var supplementaryViewHeaderModel: ViewModel?
    var supplementaryViewFooterModel: ViewModel?
    
    // MARK: - Public
    
    func register(cellClasses classes: [BaseCollectionViewCell.Type], collectionView: UICollectionView) {
        for cellClass in classes {
            collectionView.register(cellClass, forCellWithReuseIdentifier: cellClass.ca_reuseIdentifier())
        }
    }
    
    func register(supplementaryViewClasses classes: [SupplementaryViewClassWithKind], collectionView: UICollectionView) {
        for supplementaryViewClass in classes {
            let classType = supplementaryViewClass.classType
            let kind = supplementaryViewClass.kind
            collectionView.register(classType, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: classType.ca_reuseIdentifier())
        }
    }
    
    func model(atIndexPath indexPath: IndexPath) -> ViewModel? {
        assert(cellViewModels.count > 0)
        return cellViewModels[indexPath.item]
    }
    
    func supplementaryModel(atSection section: Int, kind: SupplementaryViewKind) -> ViewModel? {
        return kind == .header ? supplementaryViewHeaderModel : supplementaryViewFooterModel
    }
    
    func notify(batchUpdates: [BatchUpdate]?, completion: (() -> Void)?) {
        guard let cv = collectionView,
              let batchUpdates = batchUpdates else {
                notifyUpdate()
                return
        }
        cv.performBatchUpdates({
            self.performBatchUpdates(collectionView: cv, batchUpdates: batchUpdates)
        }) { _ in
            completion?()
        }
    }
    
    // MARK: - Private
    
    func notifyUpdate() {
        guard let cv = collectionView else { return }
        cv.reloadData()
    }
    
    
    private func performBatchUpdates(collectionView: UICollectionView, batchUpdates: [BatchUpdate]) {
        let sortedBatchUpdates = batchUpdates.sorted { $0.option.rawValue < $1.option.rawValue }
        collectionView.performBatchUpdates({
            for batch in sortedBatchUpdates {
                switch batch.option {
                case .delete:
                    collectionView.deleteItems(at: batch.indexPathes)
                    collectionView.deleteSections(batch.sections)
                    break
                case .insert:
                    collectionView.insertSections(batch.sections)
                    collectionView.insertItems(at: batch.indexPathes)
                    break
                case .update:
                    collectionView.reloadItems(at: batch.indexPathes)
                }
            }
        }, completion: nil)
    }
}

extension BaseCollectionDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModel = model(atIndexPath: indexPath) else { return UICollectionViewCell() }
        let reuseIdentifier = cellViewModel.viewClass.ca_reuseIdentifier()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BaseCollectionViewCell
        cell.viewModel = cellViewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let viewModel = supplementaryModel(atSection: indexPath.section, kind: SupplementaryViewKind(rawValue: kind)!) else { return UICollectionReusableView() }
        let reuseIdentifier = viewModel.viewClass.ca_reuseIdentifier()
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! BaseSupplementaryView
        view.viewModel = viewModel
        return view
    }
}
