//
//  Classes.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-21.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import Foundation
import UIKit
import CSKit

///The Entry class allows for the creation of user entries that can be used for Coffee Lists.
class Entry : NSObject, NSCoding, DataSaver {
    
    enum dataKey: String {
        case SavedEntries = "savedEntries"
    }
    
    var name = String()
    var coffeeType = String()
    var favCoffeeShop = String()
    var comments: String?
    private var duplicateNumber = Int()
    var duplicateNum: Int {
        return duplicateNumber
    }
    
    ///Entry initialization
    init(name: String, coffeeType: String, favCoffeeShop: String, comments: String?) {
        self.name = name
        self.coffeeType = coffeeType
        self.favCoffeeShop = favCoffeeShop
        self.comments = comments
    }
    
    ///Automatically saves the given entry to the system allowing for access of it later.
    func saveEntry() {
        var savedEntries = loadSavedEntries()
        guard savedEntries.hasValue else {
            self.duplicateNumber = 0
            let savedEntries = [self]
            saveObject(object: savedEntries, key: .SavedEntries)
            return
        }
        self.checkForDuplicate(inEntries: savedEntries!)
        savedEntries?.append(self)
        savedEntries = sortEntries(entries: savedEntries!)
        saveObject(object: savedEntries!, key: .SavedEntries)
    }
    
    ///Updates the given entry by overwriting the previous version of the entry specified
    func updateEntry(originalEntry: Entry) {
        var savedEntries = loadSavedEntries()!
        self.checkForDuplicate(inEntries: savedEntries)
        guard let index = getIndex(ofEntry: originalEntry, list: savedEntries) else {
            fatalError("Entry isn't in savedEntries")
        }
        savedEntries.remove(at: index)
        savedEntries.insert(self, at: index)
        savedEntries = sortEntries(entries: savedEntries)
        saveObject(object: savedEntries, key: .SavedEntries)
    }
    
    func removeFrom(entries: [Entry]) {
        var savedEntries = entries
        guard let index = savedEntries.index(of: self) else {
            fatalError("Entry isn't in savedEntries")
        }
        savedEntries.remove(at: index)
        saveObject(object: savedEntries, key: .SavedEntries)
    }
    
    func loadSavedEntries() -> [Entry]? {
        
//        guard let savedEntries = getSavedObject(key: .SavedEntries) as? [Entry] else {
//            return nil
//        }
//        
//        return savedEntries
        return getSavedObject(key: .SavedEntries) as? [Entry]
    }
    
    ///String representation of Entry class. This allows type Entry to be converted into type String
    override var description: String {
        let firstPart: String = "< " + String(name) + ", " + String(coffeeType) + ", "
        let secondPart: String = String(favCoffeeShop) + ", "
        let thirdPart: String = String(comments.hasValue) + ", " + String(duplicateNumber) + " >"
        //return name + ", " + coffeeType + ", " + favCoffeeShop + ", " + String(hasComment()) + ", " + duplicateNumber
        return firstPart + secondPart + thirdPart
    }
    
    ///Checks if the list of entries already contains duplicates of the current entry
    func checkForDuplicate(inEntries: [Entry]) {
        
        guard inEntries.contains(self) == true else {
            //List does not contain current entry
            self.duplicateNumber = 0
            return
        }
        
        //List contains at least one duplicate of current entry
        var counter = 0
        //Checks for number of duplicates
        for i in inEntries {
            if self.isEqual(entry: i) {
                counter += 1
            }
        }
        //Assigns duplicate number
        self.duplicateNumber = counter
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let coffeeType = aDecoder.decodeObject(forKey: "coffeeType") as! String
        let favCoffeeShop = aDecoder.decodeObject(forKey: "favCoffeeShop") as! String
        let comments = aDecoder.decodeObject(forKey: "comments") as? String
        let duplicateNumber = aDecoder.decodeInteger(forKey: "duplicateNumber")
        self.init(name: name, coffeeType: coffeeType, favCoffeeShop: favCoffeeShop, comments: comments)
        self.duplicateNumber = duplicateNumber
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(coffeeType, forKey: "coffeeType")
        aCoder.encode(favCoffeeShop, forKey: "favCoffeeShop")
        aCoder.encode(comments, forKey: "comments")
        aCoder.encode(duplicateNumber, forKey: "duplicateNumber")
        
    }
    
    static func == (entry1: Entry, entry2: Entry) -> Bool {
        return (entry1.name == entry2.name) && (entry1.coffeeType == entry2.coffeeType) && (entry1.favCoffeeShop == entry2.favCoffeeShop) && (entry1.comments == entry2.comments) && (entry1.duplicateNumber == entry2.duplicateNumber)
    }
    
    static func != (entry1: Entry, entry2: Entry) -> Bool {
        return !(entry1 == entry2)
    }
    
    ///Comparision of entries where duplicateNumber doesn't matter
    func isEqual(entry: Entry) -> Bool {
        return (self.name == entry.name) && (self.coffeeType == entry.coffeeType) && (self.favCoffeeShop == entry.favCoffeeShop) && (self.comments == entry.comments)
    }
    
    func isNotEqual(entry: Entry) -> Bool {
        return !(self.isEqual(entry: entry))
    }
    
    
}

extension Entry {
    
    func getIndex(ofEntry: Entry, list: [Entry]?) -> Int? {
        
        guard list.hasValue else {
            return nil
        }
        
        var index:Int?
        
        for i in 0..<list!.count {
            if ofEntry == list![i] {
                index = i
            }
        }
        
        guard index.hasValue else {
            return nil
        }
        
        return index
    }
    
}

public class Singleton {
    
    static let sharedInstance = Singleton()
    /*private(set)*/ var shouldUpdate = Bool()
    /*private(set)*/ var selectedEntry: Entry?
    /*private(set)*/ var selectedEntryList: EntryList?
    
    func clearAll() {
        shouldUpdate = false
        selectedEntry = nil
        selectedEntryList = nil
    }
    
    func select(value: Any, manageController: UIViewController) {
        guard (value is Entry || value is EntryList) && manageController is ManageController else {
            fatalError("Unauthorized access of Singleton")
        }
        
        if value is Entry {
            selectedEntry = value as? Entry
        } else if value is EntryList {
            selectedEntryList = value as? EntryList
        }
    }
}
