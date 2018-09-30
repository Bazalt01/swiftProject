//
//  RealmModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 25/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmModel: Object, BaseModel {
    @objc dynamic var unicID: String = UUID().uuidString
    
    override class func primaryKey() -> String {
        return "unicID"
    }
}
