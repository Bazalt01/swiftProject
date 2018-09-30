//
//  BaseSupplementaryView.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 28/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class BaseSupplementaryView: UICollectionReusableView, View {
    var viewModel: ViewModel?
    var viewModelForSize: ViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
}
