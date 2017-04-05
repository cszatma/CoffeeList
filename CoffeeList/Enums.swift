//
//  Enums.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-03-12.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import Foundation

///List of Segue Identifiers for all segues relating to ViewControllers that deal with EntryHandler Types.
enum EntryHandlerSegueIdentifiers: String {
    ///Segue Identifier for showing EditEntryController.
    case ShowEditEntry = "showEditEntry"
    ///Segue Identifier for showing ViewEntryController.
    case ShowViewEntry = "showViewEntry"
    ///Segue Identifier for showing EditEntryListController.
    case ShowEditEntryList = "showEditEntryList"
    ///Segue Identifier for showing ViewEntryController.
    case ShowViewEntryList = "showViewEntryList"
}

public enum UserDefaultsKeys: String {
    case SavedEntries = "savedEntries"
    case SavedLists = "savedLists"
}

enum EntryHandlerAction: String {
    case Add = "add"
    case Remove = "remove"
}
