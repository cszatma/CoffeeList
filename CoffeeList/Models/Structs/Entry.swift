//
//  Classes.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-21.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import QuickPersist

typealias Entries = [Entry]

/// The Entry class allows for the creation of user entries that can be used for Coffee Lists.
struct Entry: Codable {

    var name: String
    var coffeeType: String
    var favCoffeeShop: String
    var notes: String
    let id: String

    /// Entry initialization
    init(name: String, coffeeType: String, favCoffeeShop: String, notes: String, id: String = UUID().uuidString) {
        self.name = name
        self.coffeeType = coffeeType
        self.favCoffeeShop = favCoffeeShop
        self.notes = notes
        self.id = id
    }

    func update(name: String, coffeeType: String, favCoffeeShop: String, notes: String) -> Entry {
        return Entry(name: name, coffeeType: coffeeType, favCoffeeShop: favCoffeeShop, notes: notes, id: id)
    }
}

extension Entry: CLType {
    static var reuseIdentifier: String {
        return "entry"
    }

    /// Compares entry properties.
    static func ?== (lhs: Entry, rhs: Entry) -> Bool {
        return (lhs.name == rhs.name) && (lhs.coffeeType == rhs.coffeeType) &&
                (lhs.favCoffeeShop == rhs.favCoffeeShop) && (lhs.notes == rhs.notes)
    }
}

extension Entry: CustomStringConvertible {
    var description: String {
        return "< \(name), \(coffeeType), \(favCoffeeShop), \(!notes.isEmpty), \(id) >"
    }
}

extension Entry: Persistable {
    static var typeName: String {
        return "Entry"
    }

    var primaryKey: String {
        return id
    }
}
