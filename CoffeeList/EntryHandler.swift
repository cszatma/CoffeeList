//
//  EntryHandler.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-03-10.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import CSKit

///The EntryHandler Protocol provides the foundation for classes that represent a type of entry.
protocol EntryHandler: class, DataSaver {
    
    typealias action = EntryHandlerAction
    var name: String { get set }
    var duplicateNumber: Int { get set }
    typealias dataKey = UserDefaultsKeys
    init(name: String)
    
    ///Compares two EntryHandler instances of the same type. Comparision is based on all instance
    ///values being identical except for duplicateNumber.
    /// - parameter to: The EntryHandler object the current instance is being compared to.
    func isEqual(to: Self) -> Bool
    /// - parameter to: The EntryHandler object the current instance is being compared to.
    func isNotEqual(to: Self) -> Bool
    
    static func ==(lhs: Self, rhs: Self) -> Bool
    static func !=(left: Self, right: Self) -> Bool
}

extension EntryHandler {
    
    /**
    Updates the duplicate number of the given instance according to the given action.
    - parameters:
      - inArray: The array the instance is contained in.
      - action: The action to perform.
    */
    func checkForDuplicate(inArray: [Self], action: action) {
        guard inArray.contains(where: { $0 == self }) else {
            self.duplicateNumber = 0
            return
        }
        var counter = 0
        
        for i in 0..<inArray.count {
            guard self.isEqual(to: inArray[i]) else {
                continue
            }
            switch action {
            case .Add:
                counter += 1
            case .Remove:
                inArray[i].duplicateNumber -= 1
            }
        }
        self.duplicateNumber = counter
    }
    
    func isNotEqual(to: Self) -> Bool {
        return !(self.isEqual(to: to))
    }
    
    ///Adds the given instance to the stored array and saves the array to UserDefaults.
    func save() {
        let keyAndArray = Self.getArrayAndKey(ofType: Self.self)
        var savedEntryTypes = keyAndArray.0
        let key = keyAndArray.1
        
        guard savedEntryTypes.hasValue else {
            self.duplicateNumber = 0
            savedEntryTypes = [self]
            savedEntryTypes?.saveToUserDefaults(withKey: key)
            return
        }
        checkForDuplicate(inArray: savedEntryTypes!, action: .Add)
        savedEntryTypes?.append(self)
        savedEntryTypes = sortEntryType(array: savedEntryTypes!)
        savedEntryTypes?.saveToUserDefaults(withKey: key)
    }
    
    func update(original: Self) {
        let keyAndArray = Self.getArrayAndKey(ofType: Self.self)
        var savedEntryTypes = keyAndArray.0!
        let key = keyAndArray.1
        checkForDuplicate(inArray: savedEntryTypes, action: .Add)
        guard let index = savedEntryTypes.index(where: { $0 == original }) else {
           fatalError("\(Self.self) isn't in saved array")
        }
        savedEntryTypes.remove(at: index)
        savedEntryTypes.insert(self, at: index)
        savedEntryTypes = sortEntryType(array: savedEntryTypes)
        savedEntryTypes.saveToUserDefaults(withKey: key)
    }
    
    func delete() {
        let keyAndArray = Self.getArrayAndKey(ofType: Self.self)
        var savedEntryTypes = keyAndArray.0!
        let key = keyAndArray.1
        guard let index = savedEntryTypes.index(where: { $0 == self }) else {
            fatalError("\(self) isn't in savedEntries")
        }
        self.checkForDuplicate(inArray: savedEntryTypes, action: .Remove)
        savedEntryTypes.remove(at: index)
        savedEntryTypes.saveToUserDefaults(withKey: key)
    }
    
    static func getArrayAndKey(ofType: Self.Type) -> ([Self]?, UserDefaultsKeys) {
        let key = getDataKey(ofType: Self.self)
        let array = [Self].getFromUserDefaults(withKey: key)
        return (array, key)
    }
    
}


