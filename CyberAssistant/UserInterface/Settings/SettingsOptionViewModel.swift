//
//  SettingsOptionViewModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 08/10/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class SettingsOptionViewModel: SettingsViewModel {
    private var options: [TableOption]
    private var selectOption: (_ option: TableOption) -> Void
    private var router: SettingsBaseRouter
    
    // MARK: - Inits
    
    init(options: [TableOption], selectOption: @escaping (_ option: TableOption) -> Void, router: SettingsBaseRouter) {
        self.options = options
        self.selectOption = selectOption
        self.router = router
        super.init()
        self.title = NSLocalizedString("language_title", comment: "")
    }
    
    // MARK: - Public
    
    override func configure() {
        super.configure()
        sections.append(optionsSection())
    }
    
    // MARK: - Private
    
    private func optionsSection() -> TableSection {
        var section = TableSection()
        var models = [SettingOptionCellModel]()
        for option in options {
            let model = SettingOptionCellModel(option: option) { [weak self](option) in
                self?.selectOption(option)
                self?.router.popViewController()
            }
            models.append(model)
        }
        section.cellModels = models
        return section
    }
    
    
}
