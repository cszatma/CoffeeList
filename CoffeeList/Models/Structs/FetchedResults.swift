//
//  FetchedResults.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-10-05.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import RealmSwift

struct FetchedResults<T: Persistable> {
    let results: Results<Container>
    
    var count: Int {
        return results.count
    }
    
    func value(at index: Int) -> T? {
        return try? T.createFrom(realmContainer: results[index])
    }
    
    subscript(index: Int) -> T? {
        return value(at: index)
    }
}
