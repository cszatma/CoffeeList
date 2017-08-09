//
//  EntryHandler.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-03-10.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import CSKit

///The EntryHandler Protocol provides the foundation for classes that represent a type of entry.
protocol EntryHandler: class, UserDefaultsHandler {
    
    var name: String { get set }
    var notes: String { get set }
    var uid: UUID { get }
    typealias dataKey = UserDefaultsKeys
    
    ///Compares two EntryHandler instances of the same type. Comparision is based on all instance
    ///values being identical except for uid.
    /// - parameter to: The EntryHandler object the current instance is being compared to.
    func isEqual(to: Self) -> Bool
    /// - parameter to: The EntryHandler object the current instance is being compared to.
    func isNotEqual(to: Self) -> Bool
    
    static func ==(lhs: Self, rhs: Self) -> Bool
    static func !=(left: Self, right: Self) -> Bool
}

extension EntryHandler {
    
    /// Returns a Boolean value that indicates whether the receiver and a given entry type's properties are not equal.
    /// - parameter to: The entry type to compare the receiver to.
    /// - returns: `true` if the properties are not equal, `false` if they are.
    func isNotEqual(to: Self) -> Bool {
        return !(self.isEqual(to: to))
    }
    
}


