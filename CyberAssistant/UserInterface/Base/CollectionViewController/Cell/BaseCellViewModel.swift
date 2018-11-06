//
//  BaseCellViewModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 13/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class BaseCellViewModel: Hashable, ViewModel {
    private(set) var viewClass: (UIView & View).Type
    var layoutModel = LayoutModel(size: CGSize.zero)
    var isCalculatingSize: Bool = false
    
    // MARK: - Inits
    
    required init(viewClass: (UIView & View).Type) {
        self.viewClass = viewClass
    }
    
    static func == (lhs: BaseCellViewModel, rhs: BaseCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    // MARK: - Hashable
    
    var hashValue: Int {
        return Unmanaged.passUnretained(self).toOpaque().hashValue
    }
    
    func isEqual(viewModel: ViewModel) -> Bool {
        guard viewModel is BaseCellViewModel else { return false }
        return self == viewModel as! BaseCellViewModel
    }
}
