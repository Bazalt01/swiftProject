//
//  TemplateManager.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 11/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

struct TemplateRule {
    private(set) var rule: String
    private(set) var example: String
    private(set) var result: String
}

class TemplateManager: BackgroundWorker {
    private var authManager: AuthManager
    var models = [TemplateModel]()
    private var database: Database?
    let templateRules = [TemplateRule(rule: "(number)[n] - random value from 0 to n",
                                      example: "There are [10] apples.",
                                      result: "There are 8 apples."),
                         
                         TemplateRule(rule: "(number)[m-n] - random value from m to n",
                                      example: "There are [20-40] apples.",
                                      result: "There are 34 apples."),
                         
                         TemplateRule(rule: "(Any type)[a,b,c,d,...,n] - Will choose just one from sequence",
                                      example: "Dima can eat 10 [apples,kiwis,peaches] per minite.",
                                      result: "Dima can eat 10 kiwis per minute.")]
    let templateModelsObserver = PublishSubject<FetchResult?>()
    
    // MARK: - Inits
    
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    // MARK: - Public
    
    func configure() {
        guard let account = self.authManager.authorizedAccount.value else {
            _ = self.authManager.authorizedAccount.asObservable().subscribe { [weak self](newAccount) in
                guard let acc = newAccount.element! else { return }
                self?.loadContent(account: acc)
            }
            return
        }
        loadContent(account: account)
    }
    
    func createTemplate(string: String, completion: @escaping (_ template: TemplateModel) -> Void) {
        let template = RealmTemplate(value: string, muted: false, author: authManager.authorizedAccount.value!)
            DatabaseManager.database.insert(model: template) { (error) in
            completion(template)
        }
    }
    
    func saveTemplate(save: @escaping() -> Void) {
        DatabaseManager.database.update { (error) in
            save()
        }
    }
    
    func deleteTemplate(template: TemplateModel) {
        DatabaseManager.database.delete(model: template) { (error) in
        }
    }
    
    // MARK: - Private
    
    private func loadContent(account: AccountModel) {
        let sort = SortModel.init(key: "value", ascending: true)
        let observer = self.templateModelsObserver
        observer.subscribe(onNext: { [weak self](fetchResult) in
            if let result = fetchResult {
                self?.models = result.models as! [TemplateModel]
            }
        })
        
        let predicate = NSPredicate(format: "\(TemplateInternalAuthorPathKey) = %@", account.login as CVarArg)
        self.start({ [weak self] in
            let database = DatabaseManager.createDatabase()
            database.configure()
            
            database.objects(objectType: RealmTemplate.self, predicate: predicate, sortModes: [sort], observer: observer, responseQueue: DispatchQueue.main)
            self?.database = database
        })
    }
}
