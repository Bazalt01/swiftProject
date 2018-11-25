//
//  WelcomeViewModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 18/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift

class WelcomeViewModel {
    private var authManager: AuthManager
    private var router: WelcomeRouter
    
    // MARK: - Inits
    
    init(authManager: AuthManager, router: WelcomeRouter) {
        self.authManager = authManager
        self.router = router
    }
    
    // MARK: - Public
    func signIn(result: AuthResult) -> Observable<Void> {
        return sign(result: result, isSignIn: true)
    }
    
    func signUp(result: AuthResult) -> Observable<Void> {
        return sign(result: result, isSignIn: false)
    }
    
    private func sign(result: AuthResult, isSignIn: Bool) -> Observable<Void> {
        let observable = isSignIn ? authManager.signIn(result: result) : authManager.signUp(result: result)
        return observable
            .catchError { [weak self] error in
                guard let `self` = self else { return Observable<Void>.empty() }
                self.showError(error: ErrorManager.errorMessage(code: error as! ErrorCode))
                return Observable<Void>.empty()
            }
            .do(onNext: nil, onError: nil, onCompleted: { [weak self] in
                guard let `self` = self else { return }
                self.router.dismiss()
            }, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
    }
    
    func showError(error: String) {
        router.openAlertController(message: error)
    }
}
