//
//  Classes.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-21.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

typealias Entries = [Entry]

///The Entry class allows for the creation of user entries that can be used for Coffee Lists.
class Entry : NSObject, NSCoding, EntryHandler {
    
    typealias dataKey = UserDefaultsKeys
    
    var name: String
    var coffeeType: String
    var favCoffeeShop: String
    var notes: String
    let uid: UUID
    
    ///Entry initialization
    init(name: String, coffeeType: String, favCoffeeShop: String, notes: String, uid: UUID = UUID()) {
        self.name = name
        self.coffeeType = coffeeType
        self.favCoffeeShop = favCoffeeShop
        self.notes = notes
        self.uid = uid
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let coffeeType = aDecoder.decodeObject(forKey: "coffeeType") as! String
        let favCoffeeShop = aDecoder.decodeObject(forKey: "favCoffeeShop") as! String
        let notes = aDecoder.decodeObject(forKey: "notes") as! String
        let uid = UUID(uuidString: aDecoder.decodeObject(forKey: "uid") as! String)!
        self.init(name: name, coffeeType: coffeeType, favCoffeeShop: favCoffeeShop, notes: notes, uid: uid)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(coffeeType, forKey: "coffeeType")
        aCoder.encode(favCoffeeShop, forKey: "favCoffeeShop")
        aCoder.encode(notes, forKey: "notes")
        aCoder.encode(uid.uuidString, forKey: "uid")
    }
    
    ///String representation of Entry class. This allows type Entry to be converted into type String.
    override var description: String {
        return "< \(name), \(coffeeType), \(favCoffeeShop), \(!notes.isEmpty), \(uid) >"
    }
    
    static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    static func !=(lhs: Entry, rhs: Entry) -> Bool {
        return !(lhs == rhs)
    }
    
    ///Comparision of entries where uid doesn't matter.
    /// - parameter to: Entry istance is being compared to.
    func isEqual(to: Entry) -> Bool {
        return (self.name == to.name) && (self.coffeeType == to.coffeeType) && (self.favCoffeeShop == to.favCoffeeShop) && (self.notes == to.notes)
    }
    
    func update(name: String, coffeeType: String, favCoffeeShop: String, notes: String) {
        self.name = name
        self.coffeeType = coffeeType
        self.favCoffeeShop = favCoffeeShop
        self.notes = notes
    }
}
