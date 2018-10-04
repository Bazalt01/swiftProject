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
    private var database: Database?
    var models = [TemplateModel]()
    var sharedModels = [TemplateModel]()
    let templateRules = [TemplateRule(rule: NSLocalizedString("random_value_from_to", comment: ""),
                                      example: NSLocalizedString("random_value_from_to_example", comment: ""),
                                      result: NSLocalizedString("random_value_from_to_result", comment: "")),
                         
                         TemplateRule(rule: NSLocalizedString("random_value_from_m_to_n", comment: ""),
                                      example: NSLocalizedString("random_value_from_m_to_n_example", comment: ""),
                                      result: NSLocalizedString("random_value_from_m_to_n_result", comment: "")),
                         
                         TemplateRule(rule: NSLocalizedString("any_value_sequence", comment: ""),
                                      example: NSLocalizedString("any_value_sequence_example", comment: ""),
                                      result: NSLocalizedString("any_value_sequence_result", comment: ""))]
    let templateFetchResult = PublishSubject<FetchResult?>()
    
    // MARK: - Inits
    
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    // MARK: - Public
    
    func configure() {
        self.authManager.authorizedAccount.asObservable().ca_subscribe { [weak self](newAccount) in
            guard let acc = newAccount else { return }
            self?.models = []
            self?.loadContent(account: acc)
        }
    }
    
    func createTemplate(string: String, completion: ((_ template: TemplateModel) -> Void)?) {
        let template = RealmTemplate(value: string, muted: false, author: authManager.authorizedAccount.value!)
        DatabaseManager.database.insert(model: template) { (error) in
            if let compl = completion {
                compl(template)
            }
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
    
    func loadSharedContent(excludeAccount account: AccountModel, fetchResult: PublishSubject<FetchResult?>) {
        let sortAuthor = SortModel.init(key: "internalAuthor.name", ascending: true)
        let sortValue = SortModel.init(key: "value", ascending: true)
        
        let predicate = NSPredicate(format: "\(TemplateInternalAuthorPathKey) != %@ AND \(TemplateSharedKey) = 1", account.login as CVarArg)
        self.start({ [weak self] in
            let database = DatabaseManager.createDatabase()
            database.configure()
            
            database.objects(objectType: RealmTemplate.self, predicate: predicate, sortModes: [sortAuthor, sortValue], fetchResult: fetchResult, responseQueue: DispatchQueue.main)
            self?.database = database
        })
    }

    // MARK: - Private
    
    private func loadContent(account: AccountModel) {
        let sort = SortModel.init(key: "value", ascending: true)
        let fetchResult = self.templateFetchResult
        fetchResult.ca_subscribe(onNext: { [weak self](fetchResult) in
            if let result = fetchResult {
                self?.models = result.models as! [TemplateModel]
            }
        })
        
        print("[TEMPLATE_MANAGER] Load content account: \(account.login)")
        
        let predicate = NSPredicate(format: "\(TemplateInternalAuthorPathKey) = %@", account.unicID as CVarArg)
        self.start({ [weak self] in
            let database = DatabaseManager.createDatabase()
            database.configure()
            
            database.objects(objectType: RealmTemplate.self, predicate: predicate, sortModes: [sort], fetchResult: fetchResult, responseQueue: DispatchQueue.main)
            self?.database = database
        })
    }
}
