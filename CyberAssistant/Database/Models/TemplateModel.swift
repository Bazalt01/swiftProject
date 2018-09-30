//
//  TemplateModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 23/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

let TemplateInternalAuthorPathKey = "internalAuthor.unicID"
let TemplateSharedKey = "shared"

protocol SharedTemplateModel: TemplateModel {
    var saved: Bool { get set }
}

protocol TemplateModel: BaseModel {
    var value: String { get set }
    var totalValue: String { get }
    var muted: Bool { get set }
    var shared: Bool { get set }
    var author: AccountModel? { get }
    
    init(value: String, muted: Bool, author: AccountModel)
        
    func generateTemplate()
}
