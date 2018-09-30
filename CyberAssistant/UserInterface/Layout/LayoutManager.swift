//
//  CellLayoutManager.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

typealias viewClass = String

class LayoutManager {
    private var viewsByClass: [viewClass: UIView & View]
    
    // MARK: - Inits
    
    init(viewsByClass: [viewClass: UIView & View]) {
        self.viewsByClass = viewsByClass
    }
    
    // MARK: - Public
    
    func updateLayoutModel(viewModel: inout ViewModel, size: CGSize) {
        let className = NSStringFromClass(viewModel.viewClass)
        guard var view = viewsByClass[className] else {
            return
        }
        
        if viewModel.layoutModel.size.width == size.width {
            return
        }
        viewModel.isCalculatingSize = true
        view.viewModel = viewModel
        viewModel.layoutModel = LayoutModel(size: view.sizeThatFits(size))
        viewModel.isCalculatingSize = false
    }
}
