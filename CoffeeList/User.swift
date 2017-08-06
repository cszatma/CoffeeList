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
        case EntryLists
        case All
    }
    
    static let instance = User()
    var entries: Entries
    var entryLists: EntryLists
    
    private init() {
        entries = Entries.getFromUserDefaults(withKey: .SavedEntries) ?? Entries()
        entryLists = EntryLists.getFromUserDefaults(withKey: .SavedLists) ?? EntryLists()
    }
    
    func reload(selection: UserData) throws {
        if selection == .Entries || selection == .All {
            guard let savedEntries = Entries.getFromUserDefaults(withKey: .SavedEntries) else {
                throw UserDefaultsError.NoEntriesSaved
            }
            entries = savedEntries
        }
        
        if selection == .EntryLists || selection == .All {
            guard let savedEntryLists = EntryLists.getFromUserDefaults(withKey: .SavedLists) else {
                throw UserDefaultsError.NoEntryListsSaved
            }
            entryLists = savedEntryLists
        }
    }
    
    func save(selection: UserData) {
        if selection == .Entries || selection == .All {
            entries = sortEntryType(array: entries)
            entries.saveToUserDefaults(withKey: .SavedEntries)
        }
        
        if selection == .EntryLists || selection == .All {
            entryLists = sortEntryType(array: entryLists)
            entryLists.saveToUserDefaults(withKey: .SavedLists)
        }
    }
    
    func removeElement(from selection: UserData, at index: Int, shouldSave: Bool = true) {
        if selection == .Entries || selection == .All {
            entries.remove(at: index)
        }
        
        if selection == .EntryLists || selection == .All {
            entryLists.remove(at: index)
        }
        
        if shouldSave {
            save(selection: selection)   
        }
    }
}
