//
//  CoffeeList.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-17.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import SwiftySweetness
import QuickPersist

typealias CoffeeLists = [CoffeeList]
typealias CoffeeDictionary = [String: Int]

struct CoffeeList: Codable {

    var name: String
    var entries: Entries
    var notes: String
    let id: String

    init(listName: String, entries: Entries, notes: String, id: String = UUID().uuidString) {
        self.name = listName
        self.entries = entries
        self.notes = notes
        self.id = id
    }

    func update(name: String, entries: Entries, notes: String) -> CoffeeList {
        return CoffeeList(listName: name, entries: entries, notes: notes, id: id)
    }

    func generateCoffeeDictionary() -> CoffeeDictionary {
        var dictionary = CoffeeDictionary()
        entries.forEach { dictionary[$0.coffeeType, default: 0] += 1 }
        return dictionary
    }
}

extension CoffeeList: CLType {
    static var reuseIdentifier: String {
        return "coffeeList"
    }

    static func ?== (lhs: CoffeeList, rhs: CoffeeList) -> Bool {
        return (lhs.name == rhs.name) && (lhs.entries == rhs.entries) && (lhs.notes == rhs.notes)
    }
}

extension CoffeeList: CustomStringConvertible {
    var description: String {
        return "\(name): \(entries.count) entries"
    }
}

extension CoffeeList: Persistable {
    static var typeName: String {
        return "CoffeeList"
    }

    var primaryKey: String {
        return id
    }
}
