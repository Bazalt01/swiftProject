//
//  RealmAccount.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 23/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import Realm

class RealmAccount: RealmModel, AccountModel {
    @objc dynamic private(set) var login: String = ""
    @objc dynamic private(set) var password: String = ""
    @objc dynamic private(set) var name: String = ""
    @objc dynamic var authorized: Bool = false
    
    required init(login: String, password: String, name: String? = nil) {
        self.login = login
        self.password = password
        if let name = name {
            self.name = name
        } else {
            self.name = login
        }
        super.init()
        
        self.unicID = login
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
}
