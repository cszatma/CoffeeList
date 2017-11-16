//
//  Persistable.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-10-05.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import SwiftySweetness
import QuickPersist

extension Persistable {
    static func fetch(from realm: Realm, withId id: String) -> Self? {
        let op = RealmOperator(realm: realm)
        return op.value(type: Self.self, withKey: id)
    }
    
    static func fetchAll(from realm: Realm) throws -> [Self] {
        let op = RealmOperator(realm: realm)
        let results = op.values(type: Self.self)
        
        return try results.map { result -> Self in
            guard let val = result else { throw PersistableError.unableToFetch }
            return val
        }
    }
    
    func save(to realm: Realm, update: Bool) throws {
        let op = RealmOperator(realm: realm)
        try op.write { transaction in
            try transaction.add(self, update: update)
        }
    }
}
