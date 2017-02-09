//
//  EntryList.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-17.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import Foundation
import UIKit
import CSKit

class EntryList: NSObject, NSCoding, DataSaver {
    
    enum dataKey: String {
        case SavedLists = "savedLists"
    }
    
    var name = String()
    var entries: [Entry]?
    var duplicateNumber = Int()
    
    init(listName: String, entries: [Entry]?) {
        self.name = listName
        self.entries = entries
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "listName") as! String
        let entries = aDecoder.decodeObject(forKey: "listEntries") as? [Entry]
        self.init(listName: name, entries: entries)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "listName")
        aCoder.encode(entries, forKey: "listEntries")
        
    }
    
    func saveEntryList() {
        
        var savedLists = getSavedObject(key: .SavedLists) as? [EntryList]
        
        guard savedLists.hasValue else {
            self.duplicateNumber = 0
            savedLists = [self]
            saveObject(object: savedLists!, key: .SavedLists)
            return
        }
        
        self.checkForDuplicate(inEntryLists: savedLists!)
        savedLists?.append(self)
        savedLists = sortEntryLists(entryLists: savedLists!)
        saveObject(object: savedLists!, key: .SavedLists)
    }
    
    func updateEntryList(originalEntryList: EntryList) {
        
        var savedLists = getSavedObject(key: .SavedLists) as! [EntryList]
        
        self.checkForDuplicate(inEntryLists: savedLists)
        
        guard let index = getIndex(ofEntryList: originalEntryList, list: savedLists) else {
            fatalError("EntryList isn't in savedLists")
        }
        
        savedLists.remove(at: index)
        savedLists.insert(self, at: index)
        saveObject(object: savedLists, key: .SavedLists)
    }
    
    func removeFrom(entryLists: [EntryList]) {
        var savedLists = entryLists
        
        guard let index = savedLists.index(of: self) else {
            fatalError("EntryList isn't in savedLists")
        }
        
        savedLists.remove(at: index)
        saveObject(object: savedLists, key: .SavedLists)
    }
    
    func loadSavedEntryLists() -> [EntryList]? {
        
        guard let savedLists = getSavedObject(key: .SavedLists) as? [EntryList] else {
            return nil
        }
        
        return savedLists
    }
    
    ///String representation of EntryList class
    override var description: String {
        guard entries.hasValue else {
            return "\(name): nil entries"
        }
        return "\(name): \(entries!.count) entries"
    }
    
    ///Checks if the EntryList array already contains duplicates of the current EntryList
    func checkForDuplicate(inEntryLists: [EntryList]) {
        
        guard inEntryLists.contains(self) else {
            //Array does not contain current EntryList
            self.duplicateNumber = 0
            return
        }
        
        //Counter used to determine how many duplicates of the EntryList exist
        var counter = 0
        
        
        for i in inEntryLists {
            if self.isEqual(entryList: i) {
                counter += 1
            }
        }
        
        //Assigns duplicate number
        self.duplicateNumber = counter
    }

    
    static func == (left: EntryList, right: EntryList) -> Bool {
        return left.name == right.name && left.entries == right.entries && left.duplicateNumber == right.duplicateNumber
    }
    
    
    
    static func != (left: EntryList, right: EntryList) -> Bool {
        return !(left == right)
    }
    
    func isEqual(entryList: EntryList) -> Bool {
        return self.name == entryList.name && self.entries == entryList.entries
    }
    
    func isNotEqual(entryList: EntryList) -> Bool {
        return !(self.isEqual(entryList: entryList))
    }
    
    func getIndex(ofEntryList: EntryList, list: [EntryList]?) -> Int? {
        
//        guard list.hasValue else {
//            return nil
//        }
        
        guard list.hasValue else {
            return nil
        }
//        testEquality(e1: ofEntryList.entries, e2: entryLists[0].entries)
//        print(ofEntryList.entries![0])
//        print(entryLists[0].entries![0])
//        print(ofEntryList.entries![0] == entryLists[0].entries![0])
//        print(ofEntryList.entries! == entryLists[0].entries!)
        var index: Int?
        for i in 0..<list!.count {
//            print(ofEntryList.name == entryLists[i].name)
//            print(ofEntryList.entries == entryLists[i].entries)
//            print(ofEntryList.duplicateNumber == entryLists[i].duplicateNumber)
            if ofEntryList == list![i] {
                index = i
            }
        }
        
        guard index.hasValue else {
            return nil
        }
        
        return index
    }
    
    static func ~= (left: inout EntryList, right: String) {
        left.name = right
    }
    
}
