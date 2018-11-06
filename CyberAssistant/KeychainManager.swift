//
//  KeychainManager.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 23/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class KeychainManager {
    class func save(account: AccountModel) {
        save(authResult: AuthResult(login: account.login, password: account.password))
    }
    
    class func save(authResult: AuthResult) {
        let password = authResult.password.data(using: String.Encoding.utf8)!
        let query: [String : Any] = [kSecClass as String : kSecClassInternetPassword,
                     kSecAttrAccount as String : authResult.login,
                     kSecAttrServer as String : KeyChain.server,
                     kSecValueData as String : password]
        SecItemAdd(query as CFDictionary, nil)
    }
    
    class func currentAuthResult() -> AuthResult? {
        let query: [String : Any] = [kSecClass as String : kSecClassInternetPassword,
                                     kSecMatchLimit as String : kSecMatchLimitOne,
                                     kSecAttrServer as String : KeyChain.server,
                                     kSecReturnAttributes as String : true,
                                     kSecReturnData as String : true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { return nil }
        
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let login = existingItem[kSecAttrAccount as String] as? String
            else { return nil }
        
        return AuthResult(login: login, password: password)
    }
    
    class func remove(authResult: AuthResult) {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: KeyChain.server]
        SecItemDelete(query as CFDictionary)
    }
}
