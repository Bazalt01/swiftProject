//
//  RealmTemplate.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 17/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RealmTemplate: RealmModel, TemplateModel, SharedTemplateModel {
    @objc dynamic var value: String = ""
    private(set) var totalValue: String = ""
    @objc dynamic var muted: Bool = false
    @objc dynamic var shared: Bool = false
    @objc dynamic var internalAuthor: RealmAccount?
    var array: List<RealmModel>?
    var author: AccountModel? {
        return internalAuthor
    }
    var saved: Bool = false
    
    required convenience init(value: String, muted: Bool, author: AccountModel) {
        self.init()
        self.internalAuthor = author as? RealmAccount
        self.value = value
        self.muted = muted        
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    func generateTemplate() {
         totalValue = TemplateFormatter.generateTemplateResult(template: value)
    }
}

