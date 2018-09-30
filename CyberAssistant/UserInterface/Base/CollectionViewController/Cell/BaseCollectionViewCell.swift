//
//  BaseCollectionViewCell.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 13/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit

let kSwipeAnimationDuration = 0.25;

class BaseCollectionViewCell: UICollectionViewCell, CollectionViewCell {
    var viewModel: ViewModel?
    var viewModelForSize: ViewModel?    

    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public
    
    override func prepareForReuse() {
        super.prepareForReuse()        
        viewModel = nil
    }
}
