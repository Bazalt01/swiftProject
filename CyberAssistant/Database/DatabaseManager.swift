//
//  DatabaseManager.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 22/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift

struct SortModel {
    private(set) var key: String
    private(set) var ascending: Bool
}

enum BatchOption: UInt {
    case delete
    case insert
    case update
}

struct FetchResult {
    private(set) var models: [BaseModel]
    private(set) var changes: [FetchResultChanges]
}

struct FetchResultChanges {
    private(set) var option: BatchOption
    private(set) var indexes: [Int]
}

protocol Database {
    func configure()
    
    func objects(objectType: BaseModel.Type, predicate: NSPredicate?, sortModes:[SortModel]?, fetchResult: PublishSubject<FetchResult>, responseQueue: DispatchQueue)
    func object(objectType: BaseModel.Type, predicate: NSPredicate?, fetchResult: PublishSubject<FetchResult>, responseQueue: DispatchQueue)
    
    func objects(objectType: BaseModel.Type, predicate: NSPredicate?, sortModes:[SortModel]?) -> Observable<[BaseModel]>
    func object(objectType: BaseModel.Type, predicate: NSPredicate?) -> Observable<BaseModel?>
    
    func processing(operations: [(ExecuteOption, BaseModel?)]) -> Observable<Void>
    
    func update() -> Observable<Void>
    func insert(model: BaseModel) -> Observable<Void>
    func delete(model: BaseModel) -> Observable<Void>
}

class DatabaseManager {
    static let database: Database = {
        return RealmDatabase()
    }()
    
    class func createDatabase() -> Database {
        return RealmDatabase()
    }
}
