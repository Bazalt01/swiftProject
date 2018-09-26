//
//  SettingsViewModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 25/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

struct TableSection {
    var title: String?
    var cellModels: [SettingCellModel] = []
}

class SettingsViewModel {
    private var authManager: AuthManager
    private var router: SettingsRouter
    private var sections: [TableSection] = []
    
    // MARK: - Inits
    
    init(authManager: AuthManager, router: SettingsRouter) {
        self.authManager = authManager
        self.router = router
    }
    
    // MARK: - Public
    
    func configure() {
        fillSections()
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfCells(section: Int) -> Int {
        assert(sections.count > 0)
        guard sections.count > 0 else {
            return 0
        }
        return sections[section].cellModels.count
    }
    
    func cellModelAtIndexPath(indexPath: IndexPath) -> SettingCellModel {
        return sections[indexPath.section].cellModels[indexPath.item]
    }
    
    // MARK: - Private
    
    private func fillSections() {
        sections.append(profileSection())
    }
    
    private func profileSection() -> TableSection {
        var section = TableSection()
        let logout = SettingCellModelButton(title: "Logout") { [weak self] in
            self?.logout()
        }
        section.cellModels = [logout]
        return section
    }
    
    private func logout() {
        authManager.logout()
        router.openWelcomeViewController()
        router.popViewController()
    }
}
