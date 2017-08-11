//
//  User.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-06-05.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import Foundation

class User {
    
    enum UserData {
        case Entries
        case CoffeeLists
        case All
    }
    
    static let instance = User()
    var entries: Entries
    var coffeeLists: CoffeeLists
    
    private init() {
        entries = Entries.getFromUserDefaults(withKey: .SavedEntries) ?? Entries()
        coffeeLists = CoffeeLists.getFromUserDefaults(withKey: .SavedLists) ?? CoffeeLists()
    }
    
    func reload(selection: UserData) throws {
        if selection == .Entries || selection == .All {
            guard let savedEntries = Entries.getFromUserDefaults(withKey: .SavedEntries) else {
                throw UserDefaultsError.NoEntriesSaved
            }
            entries = savedEntries
        }
        
        if selection == .CoffeeLists || selection == .All {
            guard let savedCoffeeLists = CoffeeLists.getFromUserDefaults(withKey: .SavedLists) else {
                throw UserDefaultsError.NoCoffeeListsSaved
            }
            coffeeLists = savedCoffeeLists
        }
    }
    
    func save(selection: UserData) {
        if selection == .Entries || selection == .All {
            entries = sortEntryType(array: entries)
            entries.saveToUserDefaults(withKey: .SavedEntries)
        }
        
        if selection == .CoffeeLists || selection == .All {
            coffeeLists = sortEntryType(array: coffeeLists)
            coffeeLists.saveToUserDefaults(withKey: .SavedLists)
        }
    }
    
    func removeElement(from selection: UserData, at index: Int, shouldSave: Bool = true) {
        if selection == .Entries || selection == .All {
            entries.remove(at: index)
        }
        
        if selection == .CoffeeLists || selection == .All {
            coffeeLists.remove(at: index)
        }
        
        if shouldSave {
            save(selection: selection)   
        }
    }
}
