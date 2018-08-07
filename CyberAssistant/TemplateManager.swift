//
//  TemplateManager.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 11/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

struct TemplateRule {
    private(set) var rule: String
    private(set) var example: String
    private(set) var result: String
}

class TemplateManager {
    var models: [TemplateModel]
    let templateRules = [TemplateRule(rule: "(number)[n] - random value from 0 to n",
                                      example: "There are [10] apples.",
                                      result: "There are 8 apples."),
                         
                         TemplateRule(rule: "(number)[m-n] - random value from m to n",
                                      example: "There are [20-40] apples.",
                                      result: "There are 34 apples."),
                         
                         TemplateRule(rule: "(Any type)[a,b,c,d,...,n] - Will choose just one from sequence",
                                      example: "Dima can eat 10 [apples,kiwis,peaches] per minite.",
                                      result: "Dima can eat 10 kiwis per minite.")]
    var templateModelsObserver: PublishSubject<FetchResult?>
    var result: Results<RealmTemplate>?
    
    init() {
        let observer = PublishSubject<FetchResult?>()
        let sort = SortModel.init(key: "value", ascending: true)
        self.models = DatabaseManager.database.objects(objectType: RealmTemplate.self, predicate: nil, sortModes: [sort], observer: observer) as! [TemplateModel]
        self.templateModelsObserver = observer
    }
    
    func configure() {
    }
    
    func createTemplate(string: String) -> TemplateModel {
        let template = RealmTemplate(value: string, muted: false)
        
        DatabaseManager.database.insert(model: template) { (error) in
        }
        
        return template
    }
    
    func saveTemplate(save: @escaping() -> Void) {
        DatabaseManager.database.update { (error) in
            save()
        }
    }
    
    func deleteTemplate(template: TemplateModel) {
        DatabaseManager.database.delete(model: template) { (error) in
        }
    }
}
