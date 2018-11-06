//
//  SettingOptionCellModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 08/10/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class SettingOptionCellModel: SettingCellModel {
    private var option: TableOption
    
    init(option: TableOption, selectOption: @escaping (_ option: TableOption) -> Void) {
        self.option = option
        super.init(title: option.value) { selectOption(option) }
        self.cellClass = SettingOptionCell.self
    }
}
