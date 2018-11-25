//
//  SettingCellWithOptionModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 07/10/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class SettingCellWithOptionModel: SettingCellModel {
    private(set) var value: String
    
    init(title: String, value: String, selectAction: @escaping os_block_t) {
        self.value = value
        super.init(title: title, selectAction: selectAction)
        self.cellClass = SettingCellWithOption.self
    }
}
