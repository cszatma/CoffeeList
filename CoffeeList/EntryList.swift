//
//  EntryList.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-17.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

typealias EntryLists = [EntryList]

class EntryList: NSObject, NSCoding, EntryHandler {
    
    typealias dataKey = UserDefaultsKeys
    
    var name = String()
    var entries: [Entry]?
    var duplicateNumber = Int()
    
    init(listName: String, entries: [Entry]?) {
        self.name = listName
        self.entries = entries
    }
    
    ///Required init from EntryHandler Protocol. Creates a default instance with the given name, and nil entries.
    /// - parameter name: Name of EntryList.
    required convenience init(name: String) {
        self.init(listName: name, entries: nil)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "listName") as! String
        let entries = aDecoder.decodeObject(forKey: "listEntries") as? [Entry]
        let duplicateNumber = aDecoder.decodeInteger(forKey: "duplicateNumber")
        self.init(listName: name, entries: entries)
        self.duplicateNumber = duplicateNumber
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "listName")
        aCoder.encode(entries, forKey: "listEntries")
        aCoder.encode(duplicateNumber, forKey: "duplicateNumber")
    }
    
    ///String representation of EntryList class
    override var description: String {
        guard entries.hasValue else {
            return "\(name): nil entries"
        }
        return "\(name): \(entries!.count) entries"
    }
    
    static func ==(lhs: EntryList, rhs: EntryList) -> Bool {
        return lhs.name == rhs.name && lhs.entries == rhs.entries && lhs.duplicateNumber == rhs.duplicateNumber
    }
    
    static func !=(lhs: EntryList, rhs: EntryList) -> Bool {
        return !(lhs == rhs)
    }
    
    func isEqual(to: EntryList) -> Bool {
        return self.name == to.name && self.entries == to.entries
    }
    
}
