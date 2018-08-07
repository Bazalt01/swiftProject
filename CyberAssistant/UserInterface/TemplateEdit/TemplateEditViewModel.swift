//
//  TemplateEditViewModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class TemplateEditViewModel: BaseCollectionViewModel {
    private var templateManager: TemplateManager

    private(set) var template: TemplateModel?
    private(set) var router: TemplateEditRouter
    
    private(set) var dataSource: CompositeDataSource
    private(set) var editDataSource: TemplateEditDataSource
    private(set) var ruleDataSource: TemplateEditRulesDataSource
    private(set) var collectionViewDelegate: TemplateEditCollectionDelegate
    private var labelAnimator = LabelAnimator(stepDuration: 0.05)
    
    init(templateManager: TemplateManager, template: TemplateModel?, router: TemplateEditRouter) {
        self.templateManager = templateManager
        self.template = template
        self.router = router
        
        self.editDataSource = TemplateEditDataSource()
        self.ruleDataSource = TemplateEditRulesDataSource()
        self.dataSource = CompositeDataSource()
        self.dataSource.dataSources = [self.editDataSource, self.ruleDataSource]
        self.collectionViewDelegate = TemplateEditCollectionDelegate(dataSource: self.dataSource)
    }
    
    deinit {
        labelAnimator.stop()
    }
    
    func configure() {
        let templateValue = template != nil ? template!.value : ""
        editDataSource.configureAndSetCellViewModel(template: templateValue)
        ruleDataSource.configureAndSetCellViewModel(rules: self.templateManager.templateRules, labelAnimator: labelAnimator)
    }
    
    func saveTemplate() {
        if let error = _saveTemplate() {
            router.openAlertController(message: error.localizedDescription)
        }
        router.backFromEditing()
    }
    
    func _saveTemplate() -> Error? {
        guard let value = editDataSource.templateString else {
            return ErrorManager.error(code: .templateIsEmpty)
        }
        
        if value.count == 0 {
            return ErrorManager.error(code: .templateIsEmpty)
        }
        
        guard var templ = template else {
            let newTemplate = RealmTemplate(value: value, muted: false)
            DatabaseManager.database.insert(model: newTemplate) { (error) in
            }
            return nil
        }
        DatabaseManager.database.update { (error) in
            templ.value = value
        }
        
        return nil
    }
    
    func performAnimation() {
        labelAnimator.start()
    }
}
