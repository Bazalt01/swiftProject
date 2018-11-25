//
//  SpeechModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 11/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

protocol SpeechModel {
    var text: String { get }
}

struct BaseSpeechModel: SpeechModel {
    let text: String
    
    init(text: String) {
        self.text = text
    }
}
