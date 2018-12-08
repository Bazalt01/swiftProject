//
//  BaseCollectionViewDelegate.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 15/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseCollectionViewDelegate: NSObject {
    private let dataSource: BaseCollectionDataSource
    let layoutManager: LayoutManager
    
    private let didSelectSubject = PublishSubject<ViewModel>()
    var didSelect: Observable<ViewModel> {
        return didSelectSubject.share()
    }
    
    // MARK: - Inits
    
    init(layoutManager: LayoutManager, dataSource: BaseCollectionDataSource) {
        self.layoutManager = layoutManager
        self.dataSource = dataSource
    }
    
    // MARK: - Private
    
    private func maxVisibleContentSize(collectionView: UICollectionView) -> CGSize {
        var size = collectionView.bounds.size
        let contentInset = collectionView.contentInset
        size.width -= contentInset.left + contentInset.right
        size.height -= contentInset.top + contentInset.bottom
        return size
    }
}

extension BaseCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = dataSource.model(atIndexPath: indexPath) else {
            assert(false, "nullable model")
            return
        }
        didSelectSubject.onNext(model)
    }
}

extension BaseCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard var model = dataSource.model(atIndexPath: indexPath) else {
            assert(false, "nullable model")
            return .zero
        }
        let size = maxVisibleContentSize(collectionView: collectionView)
        layoutManager.updateLayoutModel(viewModel: &model, size: size)
        return model.layoutModel.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard var viewModel = dataSource.supplementaryModel(atSection: section, kind: .header) else { return .zero }
        let size = maxVisibleContentSize(collectionView: collectionView)
        layoutManager.updateLayoutModel(viewModel: &viewModel, size: size)
        return viewModel.layoutModel.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard var viewModel = dataSource.supplementaryModel(atSection: section, kind: .footer) else { return .zero }
        let size = maxVisibleContentSize(collectionView: collectionView)
        layoutManager.updateLayoutModel(viewModel: &viewModel, size: size)
        return viewModel.layoutModel.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(ca_edge: 0.0)
    }
}
