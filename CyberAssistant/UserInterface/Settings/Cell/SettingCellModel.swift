//
//  SettingCellModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

protocol SettingCellModel {
    var type: TableCellType { get }
    var title: String { get }
}
