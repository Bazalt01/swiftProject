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
    var user: SyncUser?
    let baseClasses = [RealmAccount.self, RealmTemplate.self]
    var subscribedObjects = [NotificationToken : Results<Object>]()
    
    // MARK: - Public
    
    func currentUser(success:@escaping (SyncUser) -> Void, failure:@escaping (Error) -> Void) {
        guard let currentUser = SyncUser.current else {
            let creds = SyncCredentials.nickname(RealmConfiguration.AdminNickname, isAdmin: true)
            SyncUser.logIn(with: creds, server: RealmConfiguration.AUTH_URL, onCompletion: { (user, err) in
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
    
    // MARK: - Private
    
    private func configureRealm(user: SyncUser) -> Realm {
        var config = user.configuration(realmURL: RealmConfiguration.REALM_URL, fullSynchronization: true, enableSSLValidation: false, urlPrefix: nil)
        config.objectTypes = self.baseClasses
        return try! Realm(configuration: config)
    }
    
    fileprivate func processChanges(update: RealmObserveUpdate, objects: Results<Object>, queue: DispatchQueue) -> FetchResult {
        var changes = [FetchResultChanges]()
        fillFetchResultChangess(changes: &changes, option: .delete, indexs: update.deletions)
        fillFetchResultChangess(changes: &changes, option: .insert, indexs: update.insertions)
        fillFetchResultChangess(changes: &changes, option: .update, indexs: update.modifications)
        let models = transferedObjects(objects: objects, queue: queue)
        return FetchResult(models: models, changes: changes)
    }
    
    fileprivate func processInitial(objects: Results<Object>, queue: DispatchQueue) -> FetchResult {
        var changes = [FetchResultChanges]()
        let indexs = objects.enumerated().map { (offset, element) -> Int in
            return offset
        }
        fillFetchResultChangess(changes: &changes, option: .insert, indexs: indexs)
        let models = transferedObjects(objects: objects, queue: queue)
        return FetchResult(models: models, changes: changes)
    }
    
    fileprivate func fillFetchResultChangess(changes: inout [FetchResultChanges], option: BatchOption, indexs: [Int]) {
        if indexs.count > 0 {
            let result = FetchResultChanges(option: option, indexes: indexs)
            changes.append(result)
        }
    }
    
    fileprivate func transferedObjects(objects: Results<Object>, queue: DispatchQueue) -> [BaseModel] {
        var result = [RealmModel]()
        var objectRefs = [ThreadSafeReference<Object>]()
        for object in objects {
            objectRefs.append(ThreadSafeReference(to: object))
        }
        
        queue.sync { [weak self] in
            guard let sself = self else {
                return
            }
            guard let user = sself.user else {
                return
            }
            let realm = sself.configureRealm(user: user)
            
            for objectRef in objectRefs {
                guard let object = realm.resolve(objectRef) else {
                    return
                }
                result.append(object as! RealmModel)
            }
        }
        return result
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
    func objects(objectType: BaseModel.Type, predicate: NSPredicate?, sortModes: [SortModel]?, observer: PublishSubject<FetchResult?>, responseQueue: DispatchQueue) {
        guard let rm = realm else {
            return
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
        
        let token = objects.observe { [weak self](changes: RealmCollectionChange) in
            switch changes {
            case .initial(let initialObjects):
                let result = self?.processInitial(objects: initialObjects, queue: responseQueue)
                responseQueue.async {
                    observer.onNext(result)
                }
                break
            case .update(let changedObjects, let deletions, let insertions, let modifications):
                let update = RealmObserveUpdate(deletions: deletions, insertions: insertions, modifications: modifications)
                let result = self?.processChanges(update: update, objects: changedObjects, queue: responseQueue)
                responseQueue.async {
                    observer.onNext(result)
                }
                break
            case .error( _):
                responseQueue.async {
                    observer.onNext(nil)
                }
                break
            }
        }
        subscribedObjects[token] = objects
    }
    
    func object(objectType: BaseModel.Type, predicate: NSPredicate?, observer: PublishSubject<FetchResult?>, responseQueue: DispatchQueue) {
        objects(objectType: objectType, predicate: predicate, sortModes: nil, observer: observer, responseQueue: responseQueue)
    }
    
    func objects(objectType: BaseModel.Type, predicate: NSPredicate?, sortModes:[SortModel]?) -> [BaseModel] {
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
        
        return converResultToArray(objects: objects)
    }
    
    func object(objectType: BaseModel.Type, predicate: NSPredicate?) -> BaseModel? {
        return objects(objectType: objectType, predicate: predicate, sortModes: nil).first
    }
    
    func configure() {
        currentUser(success: { [weak self](user) in
            self?.user = user
            self?.realm = self?.configureRealm(user: user)
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
