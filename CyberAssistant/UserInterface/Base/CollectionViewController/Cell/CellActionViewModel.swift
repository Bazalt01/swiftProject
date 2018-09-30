//
//  CellActionViewModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 15/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import RxSwift

enum CellActionType {
    case delete
    case mute
    case share
}

class CellActionViewModel {
    private(set) var type: CellActionType
    private(set) var selectedIcon: UIImage?
    private(set) var deselectedIcon: UIImage?
    private(set) var actionBlock: () -> Void
    
    var selected: Bool = false {
        didSet {
            self.selecteObserver.onNext(selected)
        }
    }
    
    let selecteObserver = PublishSubject<Bool>()
    
    // MARK: - Inits
    
    init(type: CellActionType, selectedIcon: UIImage?, deselectedIcon: UIImage?, actionBlock: @escaping () -> Void) {
        self.type = type
        self.selectedIcon = selectedIcon
        self.deselectedIcon = deselectedIcon
        self.actionBlock = actionBlock
    }
}
