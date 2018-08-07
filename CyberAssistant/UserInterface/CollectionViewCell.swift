//
//  CollectionViewCell.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    class func ca_reuseIdentifier() -> String {
        return NSStringFromClass(self)
    }
}

protocol CollectionViewCell {
    var viewModel: CellViewModel? { get set }
}
