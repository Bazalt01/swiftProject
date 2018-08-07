//
//  SpeechManager.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 08/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

public enum Language: String {
    case Russian = "ru-RU"
}

class SpeechConfigurator {
    private (set) var language: Language
    
    init(language: Language) {
        self.language = language
    }
}

protocol SpeechManagerDelegate {
    func didFinishPlaying(sender:SpeechManager)
}

protocol SpeechManager {
    var configurator: SpeechConfigurator { get }
    var delegate: SpeechManagerDelegate? { get set }
    
    init(configurator: SpeechConfigurator)
    
    func syntesize(text: String)
}
