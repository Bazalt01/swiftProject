//
//  RealmDatabase.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 16/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import RxSwift

struct RealmObserveUpdate {
    private(set) var deletions: [Int]
    private(set) var insertions: [Int]
    private(set) var modifications: [Int]
}

enum ExecuteOption {
    case insert
    case delete
    case update
}

class RealmDatabase {
    var realm: Realm?
    let baseClasses = [RealmAccount.self, RealmTemplate.self]
    var subscribedObjects = [NotificationToken : Results<Object>]()
    
    func currentUser(success:@escaping (SyncUser) -> Void, failure:@escaping (Error) -> Void) {
        guard let currentUser = SyncUser.current else {
            let creds = SyncCredentials.nickname(Configuration.AdminNickname, isAdmin: true)
            SyncUser.logIn(with: creds, server: Configuration.AUTH_URL, onCompletion: { (user, err) in
                if let error = err {
                    failure(error)
                }
                else if let currentUser = user {
                    success(currentUser)
                }
            })
            return
        }
        success(currentUser)
    }
    
    private func configure(user: SyncUser) {
        var config = user.configuration(realmURL: Configuration.REALM_URL, fullSynchronization: true, enableSSLValidation: false, urlPrefix: nil)
        config.objectTypes = self.baseClasses
        self.realm = try! Realm(configuration: config)
    }
    
    fileprivate func processChanges(update: RealmObserveUpdate, observer:PublishSubject<FetchResult?>, objects: Results<Object>) {
        var changes = [FetchResultChanges]()
        fillFetchResultChangess(changes: &changes, option: .delete, indexs: update.deletions)
        fillFetchResultChangess(changes: &changes, option: .insert, indexs: update.insertions)
        fillFetchResultChangess(changes: &changes, option: .update, indexs: update.modifications)
        let models = converResultToArray(objects: objects)
        let result = FetchResult(models: models, changes: changes)
        observer.onNext(result)
    }
    
    fileprivate func fillFetchResultChangess(changes: inout [FetchResultChanges], option: BatchOption, indexs: [Int]) {
        if indexs.count > 0 {
            let result = FetchResultChanges(option: option, indexes: indexs)
            changes.append(result)
        }
    }
    
    fileprivate func converResultToArray(objects: Results<Object>) -> [BaseModel] {
        var result = Array<RealmModel>()
        for object in objects {
            result.append(object as! RealmModel)
        }
        return result
    }
    
    fileprivate func execute(option: ExecuteOption, model: BaseModel?, processing: ((_ error: Error?) -> Void)?) {
        guard let rm = realm else {
            if let block = processing {
                block(ErrorManager.error(code: .enternal))
            }
            return
        }
        
        try! rm.write {
            switch option {
            case .insert:
                if let object = model {
                    rm.add(object as! Object)
                }
                break
            case .delete:
                if let object = model {
                    rm.delete(object as! Object)
                }
                break
            case .update:
                break
            }
            if let block = processing {
                block(nil)
            }
        }
    }
}

extension RealmDatabase: Database {

    func objects(objectType: BaseModel.Type, predicate: NSPredicate?, sortModes: [SortModel]?, observer: PublishSubject<FetchResult?>?) -> [BaseModel] {
        guard let rm = realm else {
            return []
        }
        
        var objects = rm.objects(objectType as! Object.Type)
        if let predic = predicate {
            objects = objects.filter(predic)
        }
        
        if let sortMs = sortModes {
            for sortModel in sortMs {
                objects = objects.sorted(byKeyPath: sortModel.key, ascending: sortModel.ascending)
            }
        }
        if let obs = observer {
            let token = objects.observe { [weak self](changes: RealmCollectionChange) in
                switch changes {
                case .initial:
                    break
                case .update(let changedObjects, let deletions, let insertions, let modifications):
                    let update = RealmObserveUpdate(deletions: deletions, insertions: insertions, modifications: modifications)
                    self?.processChanges(update: update, observer: obs, objects: changedObjects)
                    break
                case .error(let _):
                    obs.onNext(nil)
                    break
                }
            }
            subscribedObjects[token] = objects
        }
        
        return converResultToArray(objects: objects)
    }
    
    func object(objectType: BaseModel.Type, predicate: NSPredicate?, observer: PublishSubject<FetchResult?>?) -> BaseModel? {
        return objects(objectType: objectType, predicate: predicate, sortModes: nil, observer: observer).first
    }
    
    func configure() {
        currentUser(success: { [weak self](user) in
            self?.configure(user: user)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func insert(model: BaseModel, processing: ((_ error: Error?) -> Void)?) {
        execute(option: .insert, model: model, processing: processing)
    }
    
    func update(processing: ((_ error: Error?) -> Void)?) {
        execute(option: .update, model: nil, processing: processing)
    }
    
    func delete(model: BaseModel, processing: ((_ error: Error?) -> Void)?) {
        execute(option: .delete, model: model, processing: processing)
    }
}
