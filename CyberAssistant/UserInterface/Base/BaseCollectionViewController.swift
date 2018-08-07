//
//  BaseCollectionViewController.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 15/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class BaseCollectionViewController: BaseViewController {
    var collectionView: UICollectionView?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        
        configureViews()
        configureSubsciptions()
        configureAppearance()
    }
    
    func configureViews() {
        collectionView = configuredCollectionView()
        view.addSubview(collectionView!)
        collectionView!.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionContentInset()
    }
    
    private func configuredCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0.0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.alwaysBounceVertical = true
        return collectionView
    }
    
    func updateCollectionContentInset() {
        if let cv = collectionView {
            var inset = UIEdgeInsets(edge: 0.0)
            if #available(iOS 11.0, *) {
                inset.appendInsets(insets: view.safeAreaInsets)
            }
            cv.contentInset = inset
        }
    }
        
    override func viewSafeAreaInsetsDidChange() {
        if let cv = collectionView {
            var inset = view.layoutMargins
            if #available(iOS 11.0, *) {
                inset = view.safeAreaInsets
            }
            cv.contentInset = inset
        }
    }
    
    func configureSubsciptions() {
    }
    
    func configureAppearance() {
        if let cv = collectionView {
            cv.backgroundColor = UIColor.clear
        }
    }
}
