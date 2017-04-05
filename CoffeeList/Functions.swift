//
//  Functions.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-02-10.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import CSKit

@available(iOS, deprecated, message: "Use DataSaver.getFromUserDefaults(withKey: dataKey) instead.")
func loadSavedData<T: EntryHandler>(ofType: T.Type) -> [T]? {
    guard T.self is Entry.Type else {
        let entryList = EntryList(listName: "", entries: nil)
        return entryList.getSavedObject(key: .SavedLists) as? [T]
    }
    let entry = Entry(name: "", coffeeType: "", favCoffeeShop: "", comments: nil)
    return entry.getSavedObject(key: .SavedEntries) as! [T]?
}

func sortEntryType<T: EntryHandler>(array: [T]) -> [T] {
    return array.sorted(by: { $0.name < $1.name })
}

func getDataKey<T: EntryHandler>(ofType: T.Type) -> UserDefaultsKeys {
    guard T.self is Entry.Type else {
        return UserDefaultsKeys.SavedLists
    }
    return UserDefaultsKeys.SavedEntries
}


