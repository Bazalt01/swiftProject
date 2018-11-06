//
//  TemplateEditViewModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift

class TemplateEditViewModel: BaseCollectionViewModel {
    private var templateManager: TemplateManager
    private var authManager: AuthManager

    private(set) var template: TemplateModel?
    private var router: TemplateEditRouter
    
    private(set) var dataSource: CompositeDataSource
    private(set) var editDataSource: TemplateEditDataSource
    private(set) var ruleDataSource: TemplateEditRulesDataSource
    private(set) var collectionViewDelegate: TemplateEditCollectionDelegate
    
    let saveSubject = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init(templateManager: TemplateManager, authManager: AuthManager, template: TemplateModel?, router: TemplateEditRouter) {
        self.templateManager = templateManager
        self.authManager = authManager
        self.template = template
        self.router = router
        
        self.editDataSource = TemplateEditDataSource()
        self.ruleDataSource = TemplateEditRulesDataSource()
        self.dataSource = CompositeDataSource()
        self.dataSource.add(dataSource: self.editDataSource)
        self.dataSource.add(dataSource: self.ruleDataSource)
        self.collectionViewDelegate = TemplateEditCollectionDelegate(dataSource: self.dataSource)
    }
    
    // MARK: - Public
    
    func configure() {
        let templateValue = template != nil ? template!.value : ""
        editDataSource.configureAndSetCellViewModel(template: templateValue)
        ruleDataSource.configureAndSetCellViewModel(rules: self.templateManager.templateRules)
        saveSubject
            .ca_subscribe { [weak self] in
                guard let `self` = self else { return }
                _ = self._saveTemplate()
                    .catchError { [weak self] error in
                        guard let `self` = self else { return Observable<Void>.never() }
                        self.router.openAlertController(message: ErrorManager.errorMessage(code: error as! ErrorCode))
                        return Observable<Void>.empty() }
                    .subscribe(onNext: nil, onError: nil, onCompleted: { [weak self] in
                        guard let `self` = self else { return }
                        self.router.backFromEditing()
                    }, onDisposed: nil) }
            .disposed(by: disposeBag)
    }
    
    func _saveTemplate() -> Observable<Void> {
        return Observable<Void>.create({ [weak self] observer in
            guard let `self` = self,
                  let value = self.editDataSource.templateString,
                  value.count > 0 else {
                    observer.onError(ErrorCode.templateIsEmpty)
                    return Disposables.create()
            }
            
            if var template = self.template {
                _ = self.templateManager.save(template: template).subscribe(onNext: nil, onError: nil, onCompleted: {
                    template.value = value
                }, onDisposed: nil)
            } else {
                _ = self.templateManager.createTemplate(string: value).subscribe(onNext: nil, onError: nil, onCompleted: nil, onDisposed: nil)
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
}
