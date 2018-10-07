//
//  SettingCellButtonModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class SettingCellButtonModel: SettingCellModel {
    let type = TableCellType.button
    private(set) var title: String
    private(set) var action: () -> Void
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
}
