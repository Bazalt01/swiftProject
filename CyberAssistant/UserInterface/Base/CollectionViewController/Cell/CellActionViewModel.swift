//
//  CellActionViewModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 15/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum CellActionType {
    case delete
    case mute
    case share
}

class CellActionViewModel {
    private(set) var type: CellActionType
    private var selectedIcon: UIImage
    private var deselectedIcon: UIImage
    
    private let iconSubject = BehaviorRelay<UIImage>(value: UIImage())
    let actionSubject = PublishSubject<Void>()
    
    var icon: Observable<UIImage> {
       return iconSubject.share()
    }
    var didPress: Observable<Void> {
        return actionSubject.asObserver()
    }
    
    var selected: Bool = false {
        didSet {
            iconSubject.accept(selected ? selectedIcon : deselectedIcon)
        }
    }
    
    // MARK: - Inits
    
    init(type: CellActionType, selectedIcon: UIImage, deselectedIcon: UIImage) {
        self.type = type
        self.selectedIcon = selectedIcon
        self.deselectedIcon = deselectedIcon
        self.iconSubject.accept(deselectedIcon)
    }
}
