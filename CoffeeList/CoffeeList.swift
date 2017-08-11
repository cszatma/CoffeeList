//
//  CoffeeList.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-17.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

typealias CoffeeLists = [CoffeeList]
typealias CoffeeDictionary = [String: Int]

class CoffeeList: NSObject, NSCoding, EntryHandler {
    
    typealias dataKey = UserDefaultsKeys
    
    var name: String
    var entries: Entries?
    var notes: String
    let uid: UUID
    
    init(listName: String, entries: Entries?, notes: String, uid: UUID = UUID()) {
        self.name = listName
        self.entries = entries
        self.notes = notes
        self.uid = uid
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "listName") as! String
        let entries = aDecoder.decodeObject(forKey: "listEntries") as? Entries
        let notes = aDecoder.decodeObject(forKey: "notes") as! String
        let uid = UUID(uuidString: aDecoder.decodeObject(forKey: "uid") as! String)!
        self.init(listName: name, entries: entries, notes: notes, uid: uid)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "listName")
        aCoder.encode(entries, forKey: "listEntries")
        aCoder.encode(notes, forKey: "notes")
        aCoder.encode(uid.uuidString, forKey: "uid")
    }
    
    ///String representation of CoffeeList class
    override var description: String {
        guard entries.hasValue else {
            return "\(name): nil entries"
        }
        return "\(name): \(entries!.count) entries"
    }
    
    static func ==(lhs: CoffeeList, rhs: CoffeeList) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    static func !=(lhs: CoffeeList, rhs: CoffeeList) -> Bool {
        return !(lhs == rhs)
    }
    
    func isEqual(to: CoffeeList) -> Bool {
        return self.name == to.name && self.entries == to.entries && self.notes == to.notes
    }
    
    func update(name: String, entries: Entries, notes: String) {
        self.name = name
        self.entries = entries
        self.notes = notes
    }
    
    func generateCoffeeDictionary() -> CoffeeDictionary? {
        guard let entries = entries else { return nil }
        
        var dictionary = CoffeeDictionary()
        for entry in entries {
            dictionary[entry.coffeeType] = (dictionary[entry.coffeeType] ?? 0) + 1
        }
        
        return dictionary
    }
    
}
