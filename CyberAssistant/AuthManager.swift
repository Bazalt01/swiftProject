//
//  AuthManager.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 22/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class AuthManager {    
    private var authResult: AuthResult?
    private let accountSubject = BehaviorRelay<AccountModel?>(value: nil)
    private let didLogoutSubject = PublishSubject<Void>()
    
    var didLogout: Observable<Void> {
        return didLogoutSubject.share()
    }
    var account: AccountModel? {
        return accountSubject.value
    }
    var accountRelay: Observable<AccountModel?> {
        return accountSubject.share()
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init() {
        guard let authResult = KeychainManager.currentAuthResult() else { return }
                
        print("[AUTH] Start with login: \(authResult.login)")
        self.authResult = authResult
        let predicate = NSPredicate(format: "login = %@ AND password = %@", authResult.login, authResult.password)
        DatabaseManager.database.object(objectType: RealmAccount.self, predicate: predicate)
            .map { $0 as? AccountModel }
            .bind(to: accountSubject)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public
    
    func signIn(result: AuthResult) -> Observable<Void> {
        return Observable<Void>.create { observer in
            _ = self.localAccount(result: result)
                .ca_subscribe { account in
                    guard let account = account else {
                        observer.onError(ErrorCode.accountIsNotExist)
                        return
                    }
                    self.signInSideEffect(account: account)
                    observer.onCompleted() }
            return Disposables.create()
        }
    }
    
    func signUp(result: AuthResult) -> Observable<Void> {
        return Observable<Void>.create({ observer in
            guard let password = CryptoConverter.convertSHA256(string: result.password) else {
                observer.onError(ErrorCode.couldntCreateAccount)
                return Disposables.create()
            }
            
            _ = self.localAccount(result: result)
                .ca_subscribe { account in
                    guard account == nil else {
                        observer.onError(ErrorCode.accountIsExist)
                        return
                    }
                    
                    let account = RealmAccount(login: result.login, password: password, name: nil)
                    _ = DatabaseManager.database.insert(model: account)
                        .subscribe(onNext: nil, onError: { error in
                            observer.onError(error)
                        }, onCompleted: {
                            KeychainManager.save(account: account)
                            self.accountSubject.accept(account)
                            observer.onCompleted()
                        }, onDisposed: nil) }
            return Disposables.create()
        })
    }
    
    func canSignInWithLocalUser() -> Bool {
        return accountSubject.value != nil
    }

    func logout() {
        KeychainManager.remove(authResult: authResult!)
    }

    // MARK: - Private
    
    private func signInSideEffect(account: AccountModel) {
        print("[AUTH] Sign in with login: \(account.login)")
        
        self.accountSubject.accept(account)
        
        let updatedAuthResult = AuthResult(login: account.login, password: account.password)
        KeychainManager.save(authResult: updatedAuthResult)
        self.authResult = updatedAuthResult
    }
    
    private func localAccount(result: AuthResult) -> Observable<AccountModel?> {
        return DatabaseManager.database.objects(objectType: RealmAccount.self, predicate: nil, sortModes: nil)
            .flatMap { models -> Observable<AccountModel?> in
                let accounts = (models as! [AccountModel]).filter {
                    let password = CryptoConverter.convertSHA256(string: result.password)
                    return $0.login == result.login && $0.password == password
                }
                return Observable<AccountModel?>.just(accounts.first)
            }
    }
}
