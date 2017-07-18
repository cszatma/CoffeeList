//
//  Functions.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-02-10.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import CSKit

func sortEntryType<T: EntryHandler>(array: [T]) -> [T] {
    return array.sorted(by: { $0.name < $1.name })
}

func getDataKey<T: EntryHandler>(ofType: T.Type) -> UserDefaultsKeys {
    return T.self is Entry.Type ? UserDefaultsKeys.SavedEntries : UserDefaultsKeys.SavedLists
}


