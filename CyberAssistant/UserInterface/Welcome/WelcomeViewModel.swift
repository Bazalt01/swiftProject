//
//  WelcomeViewModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 18/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class WelcomeViewModel {
    private var authManager: AuthManager
    private var router: WelcomeRouter
    
    init(authManager: AuthManager, router: WelcomeRouter) {
        self.authManager = authManager
        self.router = router
    }
    
    func signIn(result: AuthResult, success: @escaping() -> Void, failure: @escaping() -> Void) {
        authManager.signIn(result: result, success: { [weak self] () in
            self?.router.dismiss()
        }) { [weak self] (error) in
            self?.router.openAlertController(message: error.localizedDescription)
            failure()
        }
    }
    
    func signUp(result: AuthResult, success: @escaping() -> Void, failure: @escaping() -> Void) {
        authManager.signUp(result: result, success: { [weak self] () in
            self?.router.dismiss()
        }) { [weak self] (error) in
            self?.router.openAlertController(message: error.localizedDescription)
            failure()
        }
    }
    
    func showError(error: Error) {
        router.openAlertController(message: error.localizedDescription)
    }
}
