//
//  SettingCellModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class SettingCellModel {
    var title: String
    var selectAction: () -> Void
    var cellClass = SettingCellView.self
    
    init(title: String, selectAction: @escaping () -> Void) {
        self.title = title
        self.selectAction = selectAction
    }
}
