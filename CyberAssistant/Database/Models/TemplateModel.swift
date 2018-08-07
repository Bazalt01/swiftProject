//
//  TemplateModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 23/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

protocol TemplateModel: BaseModel {    
    var value: String { get set }
    var totalValue: String { get }
    var muted: Bool { get set }
    
    init(value: String, muted: Bool)
    
    func generateTemplate()
}
