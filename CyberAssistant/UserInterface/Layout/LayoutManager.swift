//
//  CellLayoutManager.swift
//  CyberAssistant
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
        guard var view = viewsByClass[className],
              viewModel.layoutModel.size.width != size.width else { return }
        
        viewModel.isCalculatingSize = true
        view.viewModel = viewModel
        view.frame = CGRect(origin: .zero, size: size)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        let height = view.systemLayoutSizeFitting(CGSize(width: size.width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        let newSize = CGSize(width: size.width, height: ceil(height))
        viewModel.layoutModel = LayoutModel(size: newSize)
        viewModel.isCalculatingSize = false
    }
}
