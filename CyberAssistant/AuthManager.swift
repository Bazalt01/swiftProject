//
//  AuthManager.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 22/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RealmSwift

class AuthManager {
    private(set) var authorizedAccount: AccountModel?
    
    // MARK: - Inits
    
    init() {
        let predicate = NSPredicate(format: "authorized == 1")
        self.authorizedAccount = DatabaseManager.database.object(objectType: RealmAccount.self, predicate: predicate) as? AccountModel
    }
    
    // MARK: - Public
    
    func signIn(result: AuthResult, success: @escaping() -> Void, failure: @escaping(_ error: Error) -> Void) {
        if var account = localAccount(result: result) {
            DatabaseManager.database.update(processing: { [weak self](error) in
                account.authorized = true
                self?.authorizedAccount = account
                success()
            })
        }
        else {
            failure(ErrorManager.error(code: .accountIsNotExist))
        }
    }
    
    func signUp(result: AuthResult, success: @escaping() -> Void, failure: @escaping(_ error: Error) -> Void) {
        if let _ = localAccount(result: result) {
            failure(ErrorManager.error(code: .accountIsExist))
            return
        }
        
        let account = RealmAccount(login: result.login, password: result.password, name: nil)
        account.authorized = true
        DatabaseManager.database.insert(model: account, processing: { [weak self](error) in
            if let err = error {
                failure(err)
                return
            }
            self?.authorizedAccount = account
            success()
        })
    }
    
    func canSignInWithLocalUser() -> Bool {
        return authorizedAccount != nil
    }

    // MARK: - Private
    
    private func localAccount(result: AuthResult) -> AccountModel? {
        let accounts = DatabaseManager.database.objects(objectType: RealmAccount.self, predicate: nil, sortModes: nil) as! [RealmAccount]
        for account in accounts {
            if account.login == result.login && account.password == result.password {
                return account
            }
        }
        return nil
    }
}

