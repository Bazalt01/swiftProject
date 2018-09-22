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
    var viewModel: CellViewModel?
    var viewModelForSize: CellViewModel?    

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
    
    func configuredFittingSize(size: CGSize) -> CGSize {
        let width = size.width - contentView.layoutMargins.horizontalInset
        let height = CGFloat.greatestFiniteMagnitude
        return CGSize(width: width, height: height)
    }
}

extension BaseCollectionViewCell {
    class func className() -> String {
        return NSStringFromClass(self)
    }
}
