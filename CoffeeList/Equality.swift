//
//  Equality.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-11-16.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import Foundation

func ==<T: Equatable>(left: [T]?, right: [T]?) -> Bool {
    if !(left.hasValue) && !(right.hasValue) {
        return true //Both are nil
    } else if left.hasValue && !(right.hasValue) || !(left.hasValue) && right.hasValue {
        return false //One is nil and one has a value
    } else if left.hasValue && right.hasValue {
        print("checking")
        return left! == right!
    }
    return false
}


func == (left: Entry?, right: Entry?) -> Bool {
    if !(left.hasValue) && !(right.hasValue) {
        return true //Both are nil
    } else if left.hasValue && !(right.hasValue) || !(left.hasValue) && right.hasValue {
        return false //One is nil and one has a value
    } else if left.hasValue && right.hasValue {
        return left! == right!
    }
    return false
}

func == (left: EntryList?, right: EntryList?) -> Bool {
    if !(left.hasValue) && !(right.hasValue) {
        return true //Both are nil
    } else if left.hasValue && !(right.hasValue) || !(left.hasValue) && right.hasValue {
        return false //One is nil and one has a value
    } else if left.hasValue && right.hasValue {
        return left! == right!
    }
    return false
}

func == (left: [Entry], right: [Entry]) -> Bool {
    guard left.count == right.count else {
        return false
    }
    
    for i in 0..<left.count {
        guard left[i] == right[i] else {
            return false
        }
    }
    return true
}

func == (left: [Entry], right: [Entry]?) -> Bool {
    guard left.count == right?.count && right.hasValue else {
        return false
    }
    
    return left == right!
}

func == (left: [Entry]?, right: [Entry]) -> Bool {
    guard left?.count == right.count && left.hasValue else {
        return false
    }
    
    return left! == right
}

func == (left: [Entry]?, right: [Entry]?) -> Bool {
    if !(left.hasValue) && !(right.hasValue) {
        return true //Both are nil
    } else if left.hasValue && !(right.hasValue) || !(left.hasValue) && right.hasValue {
        return false //One is nil and one has a value
    } else if left.hasValue && right.hasValue {
        return left! == right!
    }
    return false
}
