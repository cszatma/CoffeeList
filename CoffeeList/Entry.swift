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
    
    var name = String()
    var coffeeType = String()
    var favCoffeeShop = String()
    var comments: String?
    var duplicateNumber = Int()
    
    ///Entry initialization
    init(name: String, coffeeType: String, favCoffeeShop: String, comments: String?) {
        self.name = name
        self.coffeeType = coffeeType
        self.favCoffeeShop = favCoffeeShop
        self.comments = comments
        
    }
    
    ///Required init from EntryHandler Protocol. Creates a default instance with the given name, unknown coffeeType and unknown favCoffeeShop.
    /// - parameter name: Name of Entry.
    required convenience init(name: String) {
        self.init(name: name, coffeeType: "[unknown]", favCoffeeShop: "[unknown]", comments: nil)
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
    
    ///String representation of Entry class. This allows type Entry to be converted into type String.
    override var description: String {
        return "< \(name), \(coffeeType), \(favCoffeeShop), \(comments.hasValue), \(duplicateNumber) >"
    }
    
    static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return (lhs.name == rhs.name) && (lhs.coffeeType == rhs.coffeeType) && (lhs.favCoffeeShop == rhs.favCoffeeShop) && (lhs.comments == rhs.comments) && (lhs.duplicateNumber == rhs.duplicateNumber)
    }
    
    static func !=(lhs: Entry, rhs: Entry) -> Bool {
        return !(lhs == rhs)
    }
    
    ///Comparision of entries where duplicateNumber doesn't matter.
    /// - parameter to: Entry istance is being compared to.
    func isEqual(to: Entry) -> Bool {
        return (self.name == to.name) && (self.coffeeType == to.coffeeType) && (self.favCoffeeShop == to.favCoffeeShop) && (self.comments == to.comments)
    }
    
    
}
