//
//  AuthManager.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 22/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RealmSwift
import CommonCrypto

class AuthManager {
    private(set) var authorizedAccount: AccountModel?
    
    // MARK: - Inits
    
    init() {
        guard let authResult = KeychainManager.currentAuthResult() else { return }
        
        let predicate = NSPredicate(format: "login = %@ AND password = %@", authResult.login, authResult.password)
        self.authorizedAccount = DatabaseManager.database.object(objectType: RealmAccount.self, predicate: predicate) as? AccountModel
    }
    
    // MARK: - Public
    
    func signIn(result: AuthResult, success: @escaping() -> Void, failure: @escaping(_ error: Error) -> Void) {
        guard let account = localAccount(result: result) else {
            failure(ErrorManager.error(code: .accountIsNotExist))
            return            
        }
        
        authorizedAccount = account
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

//https://stackoverflow.com/questions/25388747/sha256-in-swift

fileprivate class CryptoConverter {
    class func SHA256(_ data: Data) -> Data? {
        guard let res = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH)) else { return nil }
        CC_SHA256((data as NSData).bytes, CC_LONG(data.count), res.mutableBytes.assumingMemoryBound(to: UInt8.self))
        return res as Data
    }
    
    class func convertSHA256(string: String) -> String? {
        let targetString = string + RealmConfiguration.solt
        guard
            let data = targetString.data(using: String.Encoding.utf8),
            let shaData = SHA256(data)
            else {
                return nil
        }
        let rc = shaData.base64EncodedString(options: [])
        return rc
    }
}

