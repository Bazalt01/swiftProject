//
//  BaseCollectionViewController.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 15/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class BaseCollectionViewController: BaseViewController {
    var collectionView: UICollectionView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        
        configureViews()
        configureSubsciptions()
        configureAppearance()
    }

    // MARK: - Public
    
    func configureViews() {
        collectionView = configuredCollectionView()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func configureSubsciptions() {
    }
    
    func configureAppearance() {
        collectionView.backgroundColor = AppearanceColor.collectionBackground
    }
    
    // MARK: - Private
    
    private func configuredCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0.0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.alwaysBounceVertical = true
        return collectionView
    }
}
