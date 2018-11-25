//
//  ViewControllerAssembly.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 11/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class Assembly {
    var speechManager: SpeechManager
    let authManager = AuthManager()

    static let shared: Assembly = {
        return Assembly()
    }()

    init() {
        var language = Language.russian
        let savedLanguage = UserDefaults.standard.string(forKey: UserDefaultsKeys.languageKey)
        if let savedLanguage = savedLanguage {
            language = Language(rawValue: savedLanguage)!
        }
        let conf = SpeechConfigurator(language: language)
        self.speechManager = BaseSpeechManager()
        self.speechManager.configurator = conf
    }
    
    func configuredMainViewController() -> MainViewController {
        let tm = TemplateManager(authManager: authManager)
        let router = MainRouter()
        let vm = MainViewModel(speechManager: speechManager, templateManager: tm, router: router)
        let vc = MainViewController(viewModel: vm)
        router.routeHandler = vc
        return vc
    }
    
    func configuredTemplateViewController() -> TemplateViewController {
        let tm = TemplateManager(authManager: authManager)
        let ds = TemplateCollectionDataSource()
        let cd = TemplateCollectionDelegate(dataSource: ds)
        let router = TemplateRouter()
        let vm = TemplateViewModel(templateManager: tm, dataSource:ds, collectionViewDelegate: cd, router: router)
        let vc = TemplateViewController(viewModel: vm)
        router.routeHandler = vc
        return vc
    }
    
    func configuredTemplateEditViewController(template: TemplateModel?) -> TemplateEditViewController {
        let tm = TemplateManager(authManager: authManager)
        let router = TemplateEditRouter()
        let vm = TemplateEditViewModel(templateManager: tm, authManager: authManager, template: template, router: router)
        let vc = TemplateEditViewController(viewModel: vm)
        router.routeHandler = vc
        return vc
    }
    
    func configuredWelcomeViewController() -> WelcomeViewController {
        let router = WelcomeRouter()
        let vm = WelcomeViewModel(authManager: authManager, router: router)
        let vc = WelcomeViewController(viewModel: vm)
        router.routeHandler = vc
        return vc
    }
    
    func configuredSettingsViewController() -> SettingsViewController {
        let router = SettingsRouter()
        let vm = SettingsMainViewModel(authManager: authManager, speechManager: speechManager, router: router)
        let vc = SettingsViewController(viewModel: vm)
        router.routeHandler = vc
        return vc
    }
    
    func configuredSettingsViewController(options: [TableOption],
                                          selectOption: @escaping (_ option: TableOption) -> Void) -> SettingsViewController {
        let router = SettingsBaseRouter()
        let vm = SettingsOptionViewModel(options: options, selectOption: selectOption, router: router)
        let vc = SettingsViewController(viewModel: vm)
        router.routeHandler = vc
        return vc
    }
    
    func configuredTemplateShareViewController() -> TemplateShareViewController {
        let tm = TemplateManager(authManager: authManager)
        let router = TemplateShareRouter()
        let vm = TemplateShareViewModel(templateManager: tm, authManager: authManager, router: router)
        let vc = TemplateShareViewController(viewModel: vm)
        router.routeHandler = vc
        return vc
    }
}
