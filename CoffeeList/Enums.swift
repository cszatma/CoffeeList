//
//  Enums.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-03-12.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import Foundation

public enum UserDefaultsKeys: String {
    case SavedEntries = "savedEntries"
    case SavedLists = "savedLists"
}

enum UserDefaultsError: Error {
    case NoEntriesSaved
    case NoEntryListsSaved
}

enum AnimationType: String {
    case push = "push"
    case fade = "fade"
}
