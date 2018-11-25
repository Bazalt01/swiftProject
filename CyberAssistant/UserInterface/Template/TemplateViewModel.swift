//
//  TemplateViewModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TemplateViewModel {
    private var router: TemplateRouter
    private var templateManager: TemplateManager
    let dataSource: TemplateCollectionDataSource
    let collectionViewDelegate: BaseCollectionViewDelegate
    
    private let hasTemplatesSubject = BehaviorRelay<Bool>(value: false)
    
    var hasTemplates: Observable<Bool> {
        return hasTemplatesSubject.share()
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init(templateManager: TemplateManager, dataSource: TemplateCollectionDataSource, collectionViewDelegate: BaseCollectionViewDelegate, router: TemplateRouter) {
        self.templateManager = templateManager
        self.dataSource = dataSource
        self.collectionViewDelegate = collectionViewDelegate
        self.router = router
        
        templateManager.configure()
    }
    
    // MARK: - Public
    
    func configure() {
        configureSubsciptions()
    }
    
    func createNewTemplate() {
        router.openTemplateEditorController(template: nil)
    }
    
    func openShareTemplates() {
        router.openTemplateShareController()
    }
    
    // MARK: - Private
    
    private func configureSubsciptions() {
        templateManager.models
            .take(1)
            .ca_subscribe { [weak self] templates in
                self?.dataSource.configureAndSetCellViewModel(templateModels: templates, batchUpdates: nil)
                self?.hasTemplatesSubject.accept(templates.count > 0)}
            .disposed(by: disposeBag)
        
        templateManager.fetchResult
            .ca_subscribe { [weak self] in
                self?.processModels(fetchResult: $0) }
            .disposed(by: disposeBag)
        
        collectionViewDelegate.didSelect
            .ca_subscribe { [weak self] in
                self?.findAndOpenTemplate(cellViewModel: $0) }
            .disposed(by: disposeBag)
        
        dataSource.didActionTemplate
            .ca_subscribe { [weak self] (template, type) in
                guard let `self` = self else { return }
                var template = template
                switch type {
                case .delete:
                    _ = self.templateManager.delete(template: template).subscribe(onNext: nil, onError: nil, onCompleted: nil, onDisposed: nil)
                    break
                case .mute:
                    _ = self.templateManager.save(template: template).subscribe(onNext: nil, onError: nil, onCompleted: {
                        template.muted = !template.muted
                    }, onDisposed: nil)
                    break
                case .share:
                    _ = self.templateManager.save(template: template).subscribe(onNext: nil, onError: nil, onCompleted: {
                        template.shared = !template.shared
                    }, onDisposed: nil)
                    break
                }}
            .disposed(by: disposeBag)
    }
    
    private func findAndOpenTemplate(cellViewModel: ViewModel) {
        guard let template = dataSource.template(byCellModel: cellViewModel) else { return }
        openTemplateForEditing(template: template)
    }
    
    private func processModels(fetchResult: FetchResult?) {
        guard let result = fetchResult else { return }
        let batchUpdates = configureBatchUpdates(fetchResultChanges: result.changes)
        dataSource.configureAndSetCellViewModel(templateModels: result.models as! [TemplateModel], batchUpdates: batchUpdates)
        hasTemplatesSubject.accept(result.models.count > 0)
    }
    
    private func configureBatchUpdates(fetchResultChanges: [FetchResultChanges]) -> [BatchUpdate] {
        var batchUpdates = [BatchUpdate]()
        for fetchResultChange in fetchResultChanges {
            let indexPathes = fetchResultChange.indexes.map { IndexPath(item: $0, section: 0) }
            let batchUpdate = BatchUpdate(option: fetchResultChange.option, indexPathes: indexPathes, sections: IndexSet())
            batchUpdates.append(batchUpdate)
        }
        return batchUpdates
    }
    
    private func openTemplateForEditing(template: TemplateModel) {
        router.openTemplateEditorController(template: template)
    }
}
