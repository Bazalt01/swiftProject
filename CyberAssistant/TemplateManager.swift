//
//  TemplateManager.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 11/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

public struct TemplateRule {
    let rule: String
    let example: String
    let result: String
    init(rule: String, example: String, result: String) {
        self.rule = rule
        self.example = example
        self.result = result
    }
}

class TemplateManager: BackgroundWorker {
    private var authManager: AuthManager
    private var database: Database?
    
    let templateRules = [TemplateRule(rule: NSLocalizedString("random_value_from_to", comment: ""),
                                      example: NSLocalizedString("random_value_from_to_example", comment: ""),
                                      result: NSLocalizedString("random_value_from_to_result", comment: "")),
                         
                         TemplateRule(rule: NSLocalizedString("random_value_from_m_to_n", comment: ""),
                                      example: NSLocalizedString("random_value_from_m_to_n_example", comment: ""),
                                      result: NSLocalizedString("random_value_from_m_to_n_result", comment: "")),
                         
                         TemplateRule(rule: NSLocalizedString("any_value_sequence", comment: ""),
                                      example: NSLocalizedString("any_value_sequence_example", comment: ""),
                                      result: NSLocalizedString("any_value_sequence_result", comment: ""))]
    
    private let modelsSubject = BehaviorRelay<[TemplateModel]>(value: [])
    private let sharedModelsSubject = BehaviorSubject<[TemplateModel]>(value: [])
    private let fetchResultSubject = PublishSubject<FetchResult>()
    
    var models: Observable<[TemplateModel]> {
        return modelsSubject.share()
    }
    var sharedModels: Observable<[TemplateModel]> {
        return sharedModelsSubject.share()
    }
    var fetchResult: Observable<FetchResult> {
        return fetchResultSubject.share()
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    // MARK: - Public
    
    func configure() {
        self.authManager.accountRelay
            .ca_subscribe { [weak self] account in
                guard let `self` = self, let account = account else { return }
                self.loadContent(account: account)
            }
            .disposed(by: disposeBag)
    }
    
    func createTemplate(string: String) -> Observable<TemplateModel> {
        let template = RealmTemplate(value: string, muted: false, author: authManager.account!)
        return DatabaseManager.database.insert(model: template).flatMap { Observable<TemplateModel>.just(template) }
    }
    
    func createTemplates(strings: [String]) -> Observable<[TemplateModel]> {
        let templates = strings.map { RealmTemplate(value: $0, muted: false, author: authManager.account!) }
        let operations: [(ExecuteOption, BaseModel?)] = templates.map { (ExecuteOption.insert, $0) }
        return DatabaseManager.database.processing(operations: operations).flatMap { _ in Observable<[TemplateModel]>.from(optional: templates) }
    }
    
    func save(template: TemplateModel) -> Observable<Void> {
        return DatabaseManager.database.update()
    }
    
    func delete(template: TemplateModel) -> Observable<Void> {
        return DatabaseManager.database.delete(model: template)
    }
    
    func loadSharedContent(excludeAccount account: AccountModel, fetchResult: PublishSubject<FetchResult>) {
        let sortAuthor = SortModel(key: "internalAuthor.name", ascending: true)
        let sortValue = SortModel(key: "value", ascending: true)
        
        let predicate = NSPredicate(format: "\(TemplateInternalAuthorPathKey) != %@ AND \(TemplateSharedKey) = 1", account.login as CVarArg)
        self.start { [weak self] in
            guard let `self` = self else { return }
            let database = DatabaseManager.createDatabase()
            database.configure()
            database.objects(objectType: RealmTemplate.self, predicate: predicate, sortModes: [sortAuthor, sortValue], fetchResult: fetchResult, responseQueue: DispatchQueue.main)
            self.database = database
        }
    }

    // MARK: - Private
    
    private func loadContent(account: AccountModel) {
        let fetchResult = self.fetchResultSubject
        fetchResult
            .ca_subscribe { [weak self] fetchResult in
                guard let `self` = self else { return }
                self.modelsSubject.accept(fetchResult.models as! [TemplateModel])
            }
            .disposed(by: disposeBag)
        
        print("[TEMPLATE_MANAGER] Load content account: \(account.login)")
        
        let predicate = NSPredicate(format: "\(TemplateInternalAuthorPathKey) = %@", account.unicID as CVarArg)
        self.start({ [weak self] in
            let database = DatabaseManager.createDatabase()
            database.configure()
            
            let sort = SortModel(key: "value", ascending: true)
            database.objects(objectType: RealmTemplate.self, predicate: predicate, sortModes: [sort], fetchResult: fetchResult, responseQueue: DispatchQueue.main)
            guard let `self` = self else { return }
            self.database = database
        })
    }
}
