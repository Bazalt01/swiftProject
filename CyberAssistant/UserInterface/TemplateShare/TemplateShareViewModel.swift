//
//  TemplateShareViewModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 27/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift

class TemplateShareViewModel: BaseCollectionViewModel {
    private var router: TemplateShareRouter
    private var templateManager: TemplateManager
    private var authManager: AuthManager
    
    private(set) var dataSource: TemplateShareMainDataSource
    private(set) var collectionViewDelegate: TemplateShareCollectionDelegate
    private var templateObserver = PublishSubject<FetchResult?>()
    
    private var savedTemplatesByKeys = [String : SharedTemplateModel]()
    
    init(templateManager: TemplateManager, authManager: AuthManager, router: TemplateShareRouter) {
        self.templateManager = templateManager
        self.authManager = authManager
        self.router = router
        self.dataSource = TemplateShareMainDataSource()
        self.collectionViewDelegate = TemplateShareCollectionDelegate(dataSource: self.dataSource)
    }
    
    deinit {
        for template in savedTemplatesByKeys.values {
            templateManager.createTemplate(string: template.value, completion: nil)
        }
    }
    
    // MARK: - Public
    
    func configure() {
        configureSubscriptions()
        templateManager.loadSharedContent(excludeAccount: authManager.authorizedAccount.value!, observer: templateObserver)
    }
    
    // MARK: - Private
    
    private func configureSubscriptions() {
        templateObserver.ca_subscribe { [weak self](fetchResult) in
            self?.updateTemplates(fetchResult: fetchResult)
        }
        
        dataSource.saveObserver.ca_subscribe { [weak self](template) in
            self?.share(template: template)
        }
    }
    
    private func share(template: SharedTemplateModel) {
        savedTemplatesByKeys[template.unicID] = template.saved ? template : nil
    }
    
    private func updateTemplates(fetchResult: FetchResult?) {
        guard let fr = fetchResult else {
            return
        }
        for changes in fr.changes {
            processChange(changes: changes, templates: fr.models as! [SharedTemplateModel])
        }
    }
    
    private func processChange(changes: FetchResultChanges, templates: [SharedTemplateModel]) {
        switch changes.option {
        case .delete:
            dataSource.remove(indexes: changes.indexes)
            break
        case .insert:
            dataSource.insert(indexes: changes.indexes, templates: templates)
            break
        case .update:
            dataSource.update(indexes: changes.indexes, templates: templates)
            break
        }
    }        
}
