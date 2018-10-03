//
//  TemplateViewModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift

class TemplateViewModel {
    private var router: TemplateRouter
    private var templateManager: TemplateManager
    private(set) var dataSource: TemplateCollectionDataSource
    private(set) var collectionViewDelegate: TemplateCollectionDelegate        
    
    let hasTemplates = PublishSubject<Bool>()
    
    // MARK: - Inits
    
    init(templateManager: TemplateManager,
         dataSource: TemplateCollectionDataSource,
         collectionViewDelegate: TemplateCollectionDelegate,
         router: TemplateRouter) {
        self.templateManager = templateManager
        self.dataSource = dataSource
        self.collectionViewDelegate = collectionViewDelegate
        self.router = router
        
        templateManager.configure()
    }
    
    // MARK: - Public
    
    func configure() {
        configureSubsciptions()
        let models = self.templateManager.models
        dataSource.configureAndSetCellViewModel(templateModels: self.templateManager.models, batchUpdates: nil)
        hasTemplates.onNext(models.count > 0)
    }
    
    func createNewTemplate() {
        router.openTemplateEditorController(template: nil)
    }
    
    func openShareTemplates() {
        router.openTemplateShareController()
    }
    
    // MARK: - Private
    
    private func configureSubsciptions() {
        collectionViewDelegate.didSelectTemplate.ca_subscribe(onNext: { [weak self](cellViewModel) in
            self?.findAndOpenTemplate(cellViewModel: cellViewModel)
        })
        
        self.templateManager.templateFetchResult.ca_subscribe(onNext: { [weak self](fetchResult) in
            self?.processModels(fetchResult: fetchResult)
        })
        
        dataSource.didDeleteTemplate.ca_subscribe(onNext: { [weak self](template) in
            self?.delete(template: template)
        })
        
        dataSource.didMuteTemplate.ca_subscribe(onNext: { [weak self](template) in
            self?.mute(template: template)
        })
        
        dataSource.didShareTemplate.ca_subscribe(onNext: { [weak self](template) in
            self?.share(template: template)
        })
    }
    
    private func findAndOpenTemplate(cellViewModel: ViewModel) {
        if let template = self.dataSource.template(byCellModel: cellViewModel) {
            self.openTemplateForEditing(template: template)
        }
    }
    
    private func processModels(fetchResult: FetchResult?) {
        guard let result = fetchResult else {
            return
        }
        let batchUpdates = configureBatchUpdates(fetchResultChanges: result.changes)
        dataSource.configureAndSetCellViewModel(templateModels: result.models as! [TemplateModel], batchUpdates: batchUpdates)
        hasTemplates.onNext(result.models.count > 0)
    }
    
    private func configureBatchUpdates(fetchResultChanges: [FetchResultChanges]) -> [BatchUpdate] {
        var batchUpdates = [BatchUpdate]()
        for fetchResultChange in fetchResultChanges {
            let indexPathes = fetchResultChange.indexes.map { (index) -> IndexPath in
                return IndexPath(item: index, section: 0)
            }
            let batchUpdate = BatchUpdate(option: fetchResultChange.option, indexPathes: indexPathes, sections: IndexSet())
            batchUpdates.append(batchUpdate)
        }
        return batchUpdates
    }
    
    private func openTemplateForEditing(template: TemplateModel) {
        router.openTemplateEditorController(template: template)
    }
    
    private func delete(template: TemplateModel) {
        templateManager.deleteTemplate(template: template)
    }
    
    private func mute(template: TemplateModel) {
        var templ = template
        templateManager.saveTemplate {
            templ.muted = !templ.muted
        }
    }
    
    private func share(template: TemplateModel) {
        var templ = template
        templateManager.saveTemplate {
            templ.shared = !templ.shared
        }
    }
}
