//
//  SpeechManager.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 08/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

enum Language: String {
    case russian = "ru-RU"
    case english = "en-US"
}

struct SpeechConfigurator {
    let language: Language
    
    init(language: Language) {
        self.language = language
    }
}

protocol SpeechManagerDelegate {
    func didFinishPlaying(sender:SpeechManager)
}

protocol SpeechManager {
    var configurator: SpeechConfigurator? { get set }
    var delegate: SpeechManagerDelegate? { get set }
    var currentLanguage: Language? { get }                
    
    func syntesize(text: String)
}
