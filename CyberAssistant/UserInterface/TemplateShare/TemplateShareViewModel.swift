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
    private let router: TemplateShareRouter
    private let templateManager: TemplateManager
    private let authManager: AuthManager
    
    let dataSource: TemplateShareMainDataSource
    let collectionViewDelegate: TemplateShareCollectionDelegate
    private let didChangedSubject = PublishSubject<FetchResult>()
    
    private var savedTemplatesByKeys = [String : SharedTemplateModel]()
    private let disposeBag = DisposeBag()
    
    init(templateManager: TemplateManager, authManager: AuthManager, router: TemplateShareRouter) {
        self.templateManager = templateManager
        self.authManager = authManager
        self.router = router
        self.dataSource = TemplateShareMainDataSource()
        self.collectionViewDelegate = TemplateShareCollectionDelegate(dataSource: self.dataSource)
    }
    
    deinit {
        let strings = savedTemplatesByKeys.values.map { $0.value }
        templateManager.createTemplates(strings: strings)
            .ca_subscribe(onNext: nil)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public
    
    func configure() {
        configureSubscriptions()
        templateManager.loadSharedContent(excludeAccount: authManager.account!, fetchResult: didChangedSubject)
    }
    
    // MARK: - Private
    
    private func configureSubscriptions() {
        didChangedSubject
            .ca_subscribe { [weak self] fetchResult in
                guard let `self` = self else { return }
                fetchResult.changes.forEach { (changes) in
                    self.processChange(changes: changes, templates: fetchResult.models as! [SharedTemplateModel])
                }
            }
            .disposed(by: disposeBag)
        
        dataSource.didSaveTemplate
            .ca_subscribe { [weak self] template in
                guard let `self` = self else { return }
                self.savedTemplatesByKeys[template.unicID] = template.saved ? template : nil }
            .disposed(by: disposeBag)
    }
    
    private func share(template: SharedTemplateModel) {
        
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
