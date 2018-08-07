//
//  BaseCollectionViewDelegate.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 15/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseCollectionViewDelegate: NSObject {
    private(set) var didSelectTemplateObserver = PublishSubject<CellViewModel>()
    private(set) var cellLayoutManager: BaseCellLayoutManager
    private var dataSource: BaseDataSource
    
    init(cellLayoutManager: BaseCellLayoutManager, dataSource: BaseDataSource) {
        self.cellLayoutManager = cellLayoutManager
        self.dataSource = dataSource
    }
    
    fileprivate func maxVisibleContentSize(collectionView: UICollectionView) -> CGSize {
        var size = collectionView.bounds.size
        let contentInset = collectionView.contentInset
        size.width -= contentInset.left + contentInset.right
        size.height -= contentInset.top + contentInset.bottom
        return size
    }
}

extension BaseCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = dataSource.modelAtIndexPath(indexPath: indexPath) else {
            assert(false, "nullable model")
            return
        }
        didSelectTemplateObserver.onNext(model)
    }
}

extension BaseCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard var model = dataSource.modelAtIndexPath(indexPath: indexPath) else {
            assert(false, "nullable model")
            return CGSize.zero
        }
        let size = maxVisibleContentSize(collectionView: collectionView)
        cellLayoutManager.updateLayoutModel(cellViewModel: &model, size: size)
        return model.layoutModel.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(edge: 0.0)
    }
}
