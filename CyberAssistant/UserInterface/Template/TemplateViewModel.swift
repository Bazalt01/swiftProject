//
//  TemplateViewModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class TemplateViewModel {
    private var router: TemplateRouter
    private var templateManager: TemplateManager
    private(set) var dataSource: TemplateCollectionDataSource
    private(set) var collectionViewDelegate: TemplateCollectionDelegate
    
    init(templateManager: TemplateManager,
         dataSource: TemplateCollectionDataSource,
         collectionViewDelegate: TemplateCollectionDelegate,
         router: TemplateRouter) {
        self.templateManager = templateManager
        self.dataSource = dataSource
        self.collectionViewDelegate = collectionViewDelegate
        self.router = router
    }
    
    func configure() {
        dataSource.configureAndSetCellViewModel(templateModels: self.templateManager.models, batchUpdates: nil)
        configureSubsciptions()
    }
    
    private func configureSubsciptions() {
        collectionViewDelegate.didSelectTemplateObserver.subscribe(onNext: { [weak self](cellViewModel) in
            self?.findAndOpenTemplate(cellViewModel: cellViewModel)
        })
        
        self.templateManager.templateModelsObserver.subscribe(onNext: { [weak self](fetchResult) in
            self?.processModels(fetchResult: fetchResult)
        })
        
        dataSource.deleteTemplateObserver.subscribe(onNext: { [weak self](template) in
            self?.delete(template: template)
        })
        
        dataSource.muteTemplateObserver.subscribe(onNext: { [weak self](template) in
            self?.mute(template: template)
        })
    }
    
    private func findAndOpenTemplate(cellViewModel: CellViewModel) {
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
    }
    
    private func configureBatchUpdates(fetchResultChanges: [FetchResultChanges]) -> [BatchUpdate] {
        var batchUpdates = [BatchUpdate]()
        for fetchResultChange in fetchResultChanges {
            let batchUpdate = BatchUpdate(option: fetchResultChange.option, indexes: fetchResultChange.indexes, section: 0)
            batchUpdates.append(batchUpdate)
        }
        return batchUpdates
    }
    
    func createNewTemplate() {
        router.openTemplateEditorController(template: nil)
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
}
