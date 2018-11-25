//
//  BaseSupplementaryViewModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 28/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class BaseSupplementaryViewModel: Hashable, ViewModel {
    func createLayoutModel(fittingFrame frame: CGRect) {}
    
    private(set) var viewClass: (UIView & View).Type
    var layoutModel = LayoutModel(size: CGSize.zero)
    var isCalculatingSize: Bool = false
    
    // MARK: - Inits
    
    required init(viewClass: (UIView & View).Type) {
        self.viewClass = viewClass
    }
    
    // MARK: - Hashable
    
    static func == (lhs: BaseSupplementaryViewModel, rhs: BaseSupplementaryViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return Unmanaged.passUnretained(self).toOpaque().hashValue
    }
    
    func isEqual(viewModel: ViewModel) -> Bool {
        guard viewModel is BaseSupplementaryViewModel else { return false }
        return self == viewModel as! BaseSupplementaryViewModel
    }
}
