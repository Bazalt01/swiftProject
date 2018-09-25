//
//  AuthManager.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 22/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class AuthManager {    
    private(set) var authorizedAccount = BehaviorRelay<AccountModel?>(value: nil)
    
    // MARK: - Inits
    
    init() {
        guard let authResult = KeychainManager.currentAuthResult() else { return }
        
        let predicate = NSPredicate(format: "login = %@ AND password = %@", authResult.login, authResult.password)
        let account = DatabaseManager.database.object(objectType: RealmAccount.self, predicate: predicate) as? AccountModel
        authorizedAccount.accept(account)
    }
    
    // MARK: - Public
    
    func signIn(result: AuthResult, success: @escaping() -> Void, failure: @escaping(_ error: Error) -> Void) {
        guard let account = localAccount(result: result) else {
            failure(ErrorManager.error(code: .accountIsNotExist))
            return            
        }
        authorizedAccount.accept(account)
        let updatedAuthResult = AuthResult(login: account.login, password: account.password)
        KeychainManager.saveAuthResult(result: updatedAuthResult)
        success()
    }
    
    func signUp(result: AuthResult, success: @escaping() -> Void, failure: @escaping(_ error: Error) -> Void) {
        guard localAccount(result: result) == nil else {
            failure(ErrorManager.error(code: .accountIsExist))
            return
        }
        
        guard let password = CryptoConverter.convertSHA256(string: result.password) else {
            failure(ErrorManager.error(code: .couldntCreateAccount))
            return
        }
        
        let account = RealmAccount(login: result.login, password: password, name: nil)
        DatabaseManager.database.insert(model: account, processing: { [weak self](error) in
            if let err = error {
                failure(err)
                return
            }
            let updatedAuthResult = AuthResult(login: account.login, password: account.password)
            KeychainManager.saveAuthResult(result: updatedAuthResult)
            self?.authorizedAccount.accept(account)
            success()
        })
    }
    
    func canSignInWithLocalUser() -> Bool {
        return authorizedAccount.value != nil
    }

    // MARK: - Private
    
    private func localAccount(result: AuthResult) -> AccountModel? {
        let accounts = DatabaseManager.database.objects(objectType: RealmAccount.self, predicate: nil, sortModes: nil) as! [RealmAccount]
        for account in accounts {
            if account.login == result.login {
                let password = CryptoConverter.convertSHA256(string: result.password)
                if account.password == password {
                    return account
                }
            }
        }
        return nil
    }
}
