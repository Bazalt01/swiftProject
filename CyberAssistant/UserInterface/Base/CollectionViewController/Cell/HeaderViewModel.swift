//
//  HeaderViewModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 28/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class HeaderViewModel: BaseSupplementaryViewModel {
    var title: String
    
    // MARK: - Inits

    init(title: String) {
        self.title = title
        super.init(viewClass: HeaderView.self)
    }

    @available(*, unavailable)
    required init(viewClass: (UIView & View).Type) {
        fatalError("init(viewClass:) has not been implemented")
    }
}
