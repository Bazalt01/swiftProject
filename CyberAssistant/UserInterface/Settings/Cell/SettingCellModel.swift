//
//  SettingCellModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class SettingCellModel {
    private(set) var title: String
    private(set) var selectAction: os_block_t
    var cellClass = SettingCellView.self
    
    init(title: String, selectAction: @escaping os_block_t) {
        self.title = title
        self.selectAction = selectAction
    }
}
