//
//  AccountModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 23/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

protocol AccountModel: BaseModel {
    var login: String { get }
    var password: String { get }
    var name: String { get }
    var authorized: Bool { set get }
    
    init(login: String, password: String, name: String?)
}
