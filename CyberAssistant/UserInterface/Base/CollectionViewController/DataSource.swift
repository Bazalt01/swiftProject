//
//  DataSource.swift
//  CyberAssistant
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
    let option: BatchOption
    let indexPathes: [IndexPath]
    let sections: IndexSet?
    init(option: BatchOption, indexPathes: [IndexPath], sections: IndexSet?) {
        self.option = option
        self.indexPathes = indexPathes
        self.sections = sections
    }
}

typealias SupplementaryViewClassWithKind = (classType: BaseSupplementaryView.Type, kind: SupplementaryViewKind)

class DataSource: NSObject {
    var key: String?
    var title: String?
    var section: Int = 0
    var cellClasses: [CollectionViewCell.Type] = [] {
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
    
    var tableCellClasses: [TableViewCell.Type] = [] {
        didSet {
            guard let cv = collectionView else { return }
            register(cellClasses: cellClasses, collectionView: cv)
        }
    }
    
    weak var collectionView: UICollectionView? {
        didSet {
            guard let cv = collectionView else { return }
            register(cellClasses: cellClasses, collectionView: cv)
            register(supplementaryViewClasses: supplementaryViewClasses, collectionView: cv)
        }
    }
    
    weak var tableView: UITableView? {
        didSet {
            guard let tableView = tableView else { return }
            register(tableCellClasses: tableCellClasses, tableView: tableView)
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
    
    var cellViewModels: [ViewModel] = []
    var supplementaryViewHeaderModel: ViewModel?
    var supplementaryViewFooterModel: ViewModel?
    
    // MARK: - Public
    
    func register(cellClasses classes: [CollectionViewCell.Type], collectionView: UICollectionView) {
        for cellClass in classes {
            collectionView.register(cellClass, forCellWithReuseIdentifier: cellClass.ca_reuseIdentifier())
        }
    }
    
    func register(supplementaryViewClasses classes: [SupplementaryViewClassWithKind], collectionView: UICollectionView) {
        classes.forEach { (classType, kind) in
            collectionView.register(classType, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: classType.ca_reuseIdentifier())
        }
    }
    
    func register(tableCellClasses classes: [TableViewCell.Type], tableView: UITableView) {
        for cellClass in classes {
            tableView.register(cellClass, forCellReuseIdentifier: cellClass.ca_reuseIdentifier())
        }
    }
    
    func model(atIndexPath indexPath: IndexPath) -> ViewModel? {
        guard indexPath.item < cellViewModels.count else {
            assertionFailure()
            return nil
        }
        return cellViewModels[indexPath.item]
    }
    
    func supplementaryModel(atSection section: Int, kind: SupplementaryViewKind) -> ViewModel? {
        return kind == .header ? supplementaryViewHeaderModel : supplementaryViewFooterModel
    }
    
    func notify(batchUpdates: [BatchUpdate]?, applyBlock: os_block_t? = nil, completion: os_block_t?) {
        if let collectionView = collectionView, let batchUpdates = batchUpdates {
            collectionView.performBatchUpdates({
                applyBlock?()
                self.performBatchUpdates(collectionView: collectionView, batchUpdates: batchUpdates)
            }) { _ in
                completion?()
            }
            return
        } else if let tableView = tableView, let batchUpdates = batchUpdates {
            tableView.beginUpdates()
            applyBlock?()
            performBatchUpdates(tableView: tableView, batchUpdates: batchUpdates)
            tableView.endUpdates()
            completion?()
        }
        notifyUpdate()
    }
    
    // MARK: - Private
    
    func notifyUpdate() {
        if let collectionView = collectionView {
            collectionView.reloadData()
        }
        if let tableView = tableView {
            tableView.reloadData()
        }
    }
    
    
    private func performBatchUpdates(collectionView: UICollectionView, batchUpdates: [BatchUpdate]) {
        let sortedBatchUpdates = batchUpdates.sorted { $0.option.rawValue < $1.option.rawValue }
        for batch in sortedBatchUpdates {
            switch batch.option {
            case .delete:
                collectionView.deleteItems(at: batch.indexPathes)
                if let sections = batch.sections {
                    collectionView.deleteSections(sections)
                }
            case .insert:
                if let sections = batch.sections {
                    collectionView.insertSections(sections)
                }
                collectionView.insertItems(at: batch.indexPathes)
            case .update:
                collectionView.reloadItems(at: batch.indexPathes)
            }
        }
    }
    
    private func performBatchUpdates(tableView: UITableView, batchUpdates: [BatchUpdate]) {
        let sortedBatchUpdates = batchUpdates.sorted { $0.option.rawValue < $1.option.rawValue }
        for batch in sortedBatchUpdates {
            switch batch.option {
            case .delete:
                tableView.deleteRows(at: batch.indexPathes, with: .automatic)
                if let sections = batch.sections {
                    tableView.deleteSections(sections, with: .automatic)
                }
            case .insert:
                if let sections = batch.sections {
                    tableView.insertSections(sections, with: .automatic)
                }
                tableView.insertRows(at: batch.indexPathes, with: .automatic)
            case .update:
                tableView.reloadRows(at: batch.indexPathes, with: .automatic)
            }
        }
    }
}

extension DataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModel = model(atIndexPath: indexPath) else { return UICollectionViewCell() }
        let reuseIdentifier = cellViewModel.viewClass.ca_reuseIdentifier()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
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

extension DataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = model(atIndexPath: indexPath) else { return UITableViewCell() }
        let reuseIdentifier = cellViewModel.viewClass.ca_reuseIdentifier()
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableViewCell
        cell.viewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return title
    }
}
