//
//  CLType.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-03-10.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import UIKit

infix operator ?==: ComparisonPrecedence
infix operator ?!=: ComparisonPrecedence

///The CLType Protocol provides the foundation for classes that represent a type of entry.
protocol CLType: TableViewCompatible, Comparable {

    var name: String { get set }
    var notes: String { get set }
    var id: String { get }

    /// Compares two CLType instances of the same type. Comparision is based on all instance
    /// values being identical except for uid.
    static func ?== (lhs: Self, rhs: Self) -> Bool
    static func ?!= (lhs: Self, rhs: Self) -> Bool
}

extension CLType {

    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.name < rhs.name
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    static func != (lhs: Self, rhs: Self) -> Bool {
        return !(lhs == rhs)
    }

    /// Returns a Boolean value that indicates whether the receiver and a given entry type's properties are not equal.
    /// - returns: `true` if the properties are not equal, `false` if they are.
    static func ?!= (lhs: Self, rhs: Self) -> Bool {
        return !(lhs ?== rhs)
    }

    func cellForTableView(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = self.name
        return cell
    }
}


