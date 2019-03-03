//
//  KeychainManager.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 23/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

struct KeychainKeys {
    static let accountKey = "account"
    static let passwordKey = "password"
}

class KeychainManager {
    class func save(account: AccountModel) {
        save(authResult: AuthResult(login: account.login, password: account.password))
    }
    
    class func save(authResult: AuthResult) {
        KeychainWrapper.standard.set(authResult.login, forKey: KeychainKeys.accountKey)
        KeychainWrapper.standard.set(authResult.password, forKey: KeychainKeys.passwordKey)
    }
    
    class func currentAuthResult() -> AuthResult? {
        guard let password = KeychainWrapper.standard.string(forKey: KeychainKeys.passwordKey),
            let login = KeychainWrapper.standard.string(forKey: KeychainKeys.accountKey)
            else { return nil }
        
        return AuthResult(login: login, password: password)
    }
    
    class func remove(authResult: AuthResult) {
        KeychainWrapper.standard.removeObject(forKey: KeychainKeys.accountKey)
        KeychainWrapper.standard.removeObject(forKey: KeychainKeys.passwordKey)        
    }
}
