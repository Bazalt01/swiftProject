//
//  BaseSpeechManager.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 11/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import AVFoundation

class BaseSpeechManager : NSObject, SpeechManager, AVSpeechSynthesizerDelegate {
    fileprivate var syntesizer = AVSpeechSynthesizer()
    
    var configurator: SpeechConfigurator
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
    
    required init(configurator: SpeechConfigurator) {
        self.configurator = configurator
    }
    
    func syntesize(text: String) {
        let language = configurator.language.rawValue
        let utterance = configuredUtterance(text: text, language: language)
        syntesizer.delegate = self
        syntesizer.speak(utterance)
    }
    
    private func configuredUtterance(text: String, language: String) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        utterance.accessibilityLanguage = language
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        return utterance
    }
}

extension BaseSpeechManager {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.didFinishPlaying(sender: self)
    }
}
