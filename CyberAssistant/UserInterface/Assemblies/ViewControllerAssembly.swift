//
//  ViewControllerAssembly.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 11/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class Assembly {
    static let shared: Assembly = {
        return Assembly()
    }()

    let authManager = AuthManager()
    
    func configuredMainViewController() -> MainViewController {
        let conf = SpeechConfigurator(language: .Russian)
        let sm = BaseSpeechManager(configurator: conf)
        let tm = TemplateManager(authManager: authManager)
        let router = MainRouter()
        let vm = MainViewModel(speechManager: sm, templateManager: tm, router: router)
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
        let vm = SettingsViewModel(authManager: authManager, router: router)
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
