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
    private var realm: Realm?
    private var user: SyncUser?
    private let baseClasses = [RealmAccount.self, RealmTemplate.self]
    private var subscribedObjects: [NotificationToken : Results<Object>] = [:]
    private let bag = DisposeBag()
    
    // MARK: - Public
    func currentUser() -> Observable<SyncUser> {
        return Observable<SyncUser>.create { (observer) -> Disposable in
            guard let currentUser = SyncUser.current else {
                let creds = SyncCredentials.nickname(RealmConfiguration.AdminNickname, isAdmin: true)
                SyncUser.logIn(with: creds, server: RealmConfiguration.AUTH_URL, onCompletion: { (user, err) in
                    if let error = err {
                        observer.onError(error)
                    }
                    guard let currentUser = user else {
                        observer.onError(ErrorCode.enternal)
                        return
                    }
                    observer.onNext(currentUser)
                })
                return Disposables.create()
            }
            observer.onNext(currentUser)
            return Disposables.create()
        }
    }
    
    // MARK: - Private
    
    private func configureRealm(user: SyncUser) -> Realm {
        var config = user.configuration(realmURL: RealmConfiguration.REALM_URL, fullSynchronization: true, enableSSLValidation: false, urlPrefix: nil)
        config.objectTypes = self.baseClasses
        return try! Realm(configuration: config)
    }
    
    fileprivate func processChanges(update: RealmObserveUpdate, objects: Results<Object>, queue: DispatchQueue) -> FetchResult {
        var changes: [FetchResultChanges] = []
        fillFetchResultChangess(changes: &changes, option: .delete, indexs: update.deletions)
        fillFetchResultChangess(changes: &changes, option: .insert, indexs: update.insertions)
        fillFetchResultChangess(changes: &changes, option: .update, indexs: update.modifications)
        let models = transferedObjects(objects: objects, queue: queue)
        return FetchResult(models: models, changes: changes)
    }
    
    fileprivate func processInitial(objects: Results<Object>, queue: DispatchQueue) -> FetchResult {
        var changes: [FetchResultChanges] = []
        let indexs = objects.enumerated().map { $0.offset }
        fillFetchResultChangess(changes: &changes, option: .insert, indexs: indexs)
        let models = transferedObjects(objects: objects, queue: queue)
        return FetchResult(models: models, changes: changes)
    }
    
    fileprivate func fillFetchResultChangess(changes: inout [FetchResultChanges], option: BatchOption, indexs: [Int]) {
        guard indexs.count > 0 else { return }
        let result = FetchResultChanges(option: option, indexes: indexs)
        changes.append(result)
    }
    
    fileprivate func transferedObjects(objects: Results<Object>, queue: DispatchQueue) -> [BaseModel] {
        var result: [RealmModel] = []
        var objectRefs: [ThreadSafeReference<Object>] = []
        for object in objects {
            objectRefs.append(ThreadSafeReference(to: object))
        }
        
        queue.sync { [weak self] in
            guard let `self` = self, let user = self.user else { return }
            let realm = self.configureRealm(user: user)
            
            for objectRef in objectRefs {
                guard let object = realm.resolve(objectRef) else { return }
                result.append(object as! RealmModel)
            }
        }
        return result
    }
    
    fileprivate func converResultToArray(objects: Results<Object>) -> [BaseModel] {
        var result: [RealmModel] = []
        for object in objects {
            result.append(object as! RealmModel)
        }
        return result
    }
    
    fileprivate func sortDescriptors(sortModels: [SortModel]) -> [SortDescriptor] {
        return sortModels.map { return SortDescriptor(keyPath: $0.key, ascending: $0.ascending) }
    }
}

extension RealmDatabase: Database {
    func objects(objectType: BaseModel.Type, predicate: NSPredicate?, sortModes: [SortModel]?, fetchResult: PublishSubject<FetchResult>, responseQueue: DispatchQueue) {
        guard let rm = realm else { return }
        
        var objects = rm.objects(objectType as! Object.Type)
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        
        if let sortModes = sortModes {
            objects = objects.sorted(by: sortDescriptors(sortModels: sortModes))
        }
        
        let token = objects.observe { [weak self] changes in
            guard let `self` = self else { return }
            switch changes {
            case .initial(let initialObjects):
                let result = self.processInitial(objects: initialObjects, queue: responseQueue)
                responseQueue.async {
                    fetchResult.onNext(result)
                }
                break
            case .update(let changedObjects, let deletions, let insertions, let modifications):
                let update = RealmObserveUpdate(deletions: deletions, insertions: insertions, modifications: modifications)
                let result = self.processChanges(update: update, objects: changedObjects, queue: responseQueue)
                responseQueue.async {
                    fetchResult.onNext(result)
                }
                break
            case .error( _):
                responseQueue.async {
                    fetchResult.onError(ErrorCode.enternal)
                }
                break
            }
        }
        subscribedObjects[token] = objects
    }
    
    func object(objectType: BaseModel.Type, predicate: NSPredicate?, fetchResult: PublishSubject<FetchResult>, responseQueue: DispatchQueue) {
        objects(objectType: objectType, predicate: predicate, sortModes: nil, fetchResult: fetchResult, responseQueue: responseQueue)
    }
    
    func objects(objectType: BaseModel.Type, predicate: NSPredicate?, sortModes:[SortModel]?) -> Observable<[BaseModel]> {
        return Observable<[BaseModel]>.create({ [weak self] (observer) -> Disposable in
            guard let `self` = self, let rm = self.realm else {
                observer.onNext([])
                return Disposables.create()
            }
            
            var objects = rm.objects(objectType as! Object.Type)
            if let predicate = predicate {
                objects = objects.filter(predicate)
            }
            
            if let sortModes = sortModes {
                objects = objects.sorted(by: self.sortDescriptors(sortModels: sortModes))
            }
            observer.onNext(self.converResultToArray(objects: objects))
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func object(objectType: BaseModel.Type, predicate: NSPredicate?) -> Observable<BaseModel?> {
        return objects(objectType: objectType, predicate: predicate, sortModes: nil).map { $0.first }
    }
    
    func configure() {
        currentUser()
            .subscribe(onNext: { [weak self] user in
            guard let `self` = self else { return }
            self.user = user
            self.realm = self.configureRealm(user: user)
            }, onError: { print($0.localizedDescription) }, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
    
    func processing(operations: [(ExecuteOption, BaseModel?)]) -> Observable<Void> {
        return Observable<Void>.create({ [unowned self] observer in
            guard let rm = self.realm else {
                observer.onError(ErrorCode.enternal)
                return Disposables.create()
            }
            
            try! rm.write {
                operations.forEach { (option, model) in
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
                }
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }
    
    func insert(model: BaseModel) -> Observable<Void> {
        return processing(operations: [(.insert, model)])
    }
    
    func update() -> Observable<Void> {
        return processing(operations: [(.update, nil)])
    }
    
    func delete(model: BaseModel) -> Observable<Void> {
        return processing(operations: [(.delete, model)])
    }
}
