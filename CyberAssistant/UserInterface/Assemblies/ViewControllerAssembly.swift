//
//  ViewControllerAssembly.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 11/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class ViewControllerAssembly {
    class func configuredMainViewController() -> MainViewController {
        let conf = SpeechConfigurator(language: .Russian)
        let sm = BaseSpeechManager(configurator: conf)
        let tm = TemplateManager()
        let router = MainRouter()
        let vm = MainViewModel(speechManager: sm, templateManager: tm, router: router)
        let vc = MainViewController(viewModel: vm)
        router.routeHandler = vc
        return vc
    }
    
    class func configuredTemplateViewController() -> TemplateViewController {
        let tm = TemplateManager()
        let ds = TemplateCollectionDataSource()
        let cd = TemplateCollectionDelegate(dataSource: ds)
        let router = TemplateRouter()
        let vm = TemplateViewModel(templateManager: tm, dataSource:ds, collectionViewDelegate: cd, router: router)
        let vc = TemplateViewController(viewModel: vm)
        router.routeHandler = vc
        return vc
    }
    
    class func configuredTemplateEditViewController(template: TemplateModel?) -> TemplateEditViewController {
        let tm = TemplateManager()
        let router = TemplateEditRouter()
        let vm = TemplateEditViewModel(templateManager: tm, template: template, router: router)
        let vc = TemplateEditViewController(viewModel: vm)
        router.routeHandler = vc
        return vc
    }
    
    class func configuredWelcomeViewController(authManager: AuthManager) -> WelcomeViewController {
        let router = WelcomeRouter()
        let vm = WelcomeViewModel(authManager: authManager, router: router)
        let vc = WelcomeViewController(viewModel: vm)
        router.routeHandler = vc
        return vc
    }
}
