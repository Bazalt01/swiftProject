//
//  SettingCellButtonModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 08/10/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class SettingCellButtonModel: SettingCellModel {
    override init(title: String, selectAction: @escaping os_block_t) {
        super.init(title: title, selectAction: selectAction)
        self.cellClass = SettingCellButton.self
    }
}

