//
//  RealmTemplate.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 17/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RealmTemplate: RealmModel, TemplateModel {
    @objc dynamic var value: String = ""
    private(set) var totalValue: String = ""
    @objc dynamic var muted: Bool = false
    
    required convenience init(value: String, muted: Bool) {
        self.init()
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

