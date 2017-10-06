//
//  WriteTransaction.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-10-05.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import RealmSwift

struct WriteTransaction {
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func add<T: Persistable>(_ value: T, update: Bool) throws {
        realm.add(try value.realmContainer(), update: update)
    }
    
    func delete<T: Persistable>(_ value: T) throws {
        realm.delete(try value.realmContainer())
    }
}
