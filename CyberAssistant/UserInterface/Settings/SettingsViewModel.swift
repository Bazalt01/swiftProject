//
//  SettingsViewModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 25/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift

struct TableSection {
    var title: String?
    var cellModels: [SettingCellModel] = []
}

struct TableOption {
    var value: String
    var key: String
    var selected: Bool
}

class SettingsViewModel {
    var sections: [TableSection] = []
    var title = ""
    
    let didReloadDataSubject = PublishSubject<Void>()
    
    var didReloadData: Observable<Void> {
        return didReloadDataSubject.share()
    }
    
    // MARK: - Public
    
    func configure() {}
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfCells(section: Int) -> Int {
        assert(sections.count > 0)
        guard sections.count > 0 else { return 0 }
        return sections[section].cellModels.count
    }
    
    func cellModelAtIndexPath(indexPath: IndexPath) -> SettingCellModel {
        return sections[indexPath.section].cellModels[indexPath.item]
    }        
}
