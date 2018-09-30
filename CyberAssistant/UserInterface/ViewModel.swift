//
//  ViewModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

protocol ViewModel {
    var viewClass: (UIView & View).Type { get }
    var layoutModel: LayoutModel { get set }
    var isCalculatingSize: Bool { get set }
    
    // MARK: - Inits
    
    init(viewClass: (UIView & View).Type)
    
    func isEqual(viewModel: ViewModel) -> Bool
}
