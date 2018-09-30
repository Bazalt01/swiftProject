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
    
    func objects(objectType: BaseModel.Type, predicate: NSPredicate?, sortModes:[SortModel]?, observer: PublishSubject<FetchResult?>, responseQueue: DispatchQueue)
    func object(objectType: BaseModel.Type, predicate: NSPredicate?, observer: PublishSubject<FetchResult?>, responseQueue: DispatchQueue)
    
    func objects(objectType: BaseModel.Type, predicate: NSPredicate?, sortModes:[SortModel]?) -> [BaseModel]
    func object(objectType: BaseModel.Type, predicate: NSPredicate?) -> BaseModel?
    func update(processing: ((_ error: Error?) -> Void)?)
    func insert(model: BaseModel, processing: ((_ error: Error?) -> Void)?)
    func delete(model: BaseModel, processing: ((_ error: Error?) -> Void)?)
}

class DatabaseManager {
    static let database: Database = {
        return RealmDatabase()
    }()
    
    class func createDatabase() -> Database {
        return RealmDatabase()
    }
}
