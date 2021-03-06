//
//  BaseSpeechManager.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 11/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import AVFoundation

class BaseSpeechManager : NSObject, SpeechManager {
    fileprivate var syntesizer = AVSpeechSynthesizer()
    
    var configurator: SpeechConfigurator?
    private var _delegate: SpeechManagerDelegate?
    var delegate: SpeechManagerDelegate? {
        get {
            return _delegate
        }
        set (delegate) {
            syntesizer.delegate = self
            _delegate = delegate
        }
    }
    
    var currentLanguage: Language? {
        return configurator?.language
    }
    
    // MARK: - Inits
    
    override init() {
        super.init()
    }
    
    // MARK: - Public
    
    func syntesize(text: String) {
        guard let conf = configurator else { return }
        let language = conf.language.rawValue
        let utterance = configuredUtterance(text: text, language: language)
        syntesizer.delegate = self
        syntesizer.speak(utterance)
    }
    
    func stopSyntesize() {
        syntesizer.stopSpeaking(at: .immediate)
    }
    
    // MARK: - Private
    
    private func configuredUtterance(text: String, language: String) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        utterance.accessibilityLanguage = language
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        return utterance        
    }
}

extension BaseSpeechManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.didFinishPlaying(sender: self)
    }
}
