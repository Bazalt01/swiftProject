//
//  SettingsMainViewModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 08/10/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift

class SettingsMainViewModel: SettingsViewModel {
    private var authManager: AuthManager
    private var speechManager: SpeechManager
    private var router: SettingsRouter    
    private var languages: [Language : String] = [.russian : NSLocalizedString("russian_language", comment: ""),
                                                  .english : NSLocalizedString("english_language", comment: "")]
    
    init(authManager: AuthManager, speechManager: SpeechManager, router: SettingsRouter) {
        self.authManager = authManager
        self.speechManager = speechManager
        self.router = router
        super.init()
        self.title = NSLocalizedString("settings", comment: "")
    }
    
    // MARK: - Public
    
    override func configure() {
        super.configure()
        sections.append(speechLanguageSection())
        sections.append(profileSection())
    }
    
    // MARK: - Private
    
    private func profileSection() -> TableSection {
        var section = TableSection()
        let logout = SettingCellButtonModel(title: NSLocalizedString("logout", comment: "")) { [weak self] in
            self?.logout()
        }
        section.cellModels = [logout]
        return section
    }
    
    private func speechLanguageSection() -> TableSection {
        var section = TableSection()
        let title = NSLocalizedString("language_title", comment: "")
        let value = NSLocalizedString(languages[speechManager.currentLanguage!]!, comment: "")
        let languageModel = SettingCellWithOptionModel(title: title, value: value) { [weak self] in
            self?.openLanguageOptionList()
        }
        section.cellModels = [languageModel]
        return section
    }
    
    private func openLanguageOptionList() {
        let russianValue = NSLocalizedString(languages[.russian]!, comment: "")
        let russianOption = TableOption(value: russianValue, key: Language.russian.rawValue, selected: speechManager.currentLanguage == .russian)
        
        let englishValue = NSLocalizedString(languages[.english]!, comment: "")
        let englishOption = TableOption(value: englishValue, key: Language.english.rawValue, selected: speechManager.currentLanguage == .english)
        
        router.openOptionListViewController(options: [russianOption, englishOption]) { [weak self] option in
            self?.updateSpeechConfiguration(language: Language.init(rawValue: option.key)!)
        }
    }
    
    private func updateSpeechConfiguration(language: Language) {
        UserDefaults.standard.set(language.rawValue, forKey: UserDefaultsKeys.languageKey)
        speechManager.configurator = SpeechConfigurator(language: language)
        sections.remove(at: 0)
        sections.insert(speechLanguageSection(), at: 0)
        didReloadDataSubject.onNext(())
    }
    
    private func logout() {
        authManager.logout()
        router.openWelcomeViewController()
        router.popViewController()
    }
}
