//
//  Extensions.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-06.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import Foundation
import UIKit

infix operator ~=: AssignmentPrecedence

//Global Functions:

func sortEntries(entries: [Entry]) -> [Entry] {
    let sortedEntries = entries.sorted(by: { $0.name < $1.name })
    return sortedEntries
}

func sortEntryLists(entryLists: [EntryList]) -> [EntryList] {
    let sortedEntryLists = entryLists.sorted(by: { $0.name < $1.name })
    return sortedEntryLists
}



func testEquality(e1: [Entry]?, e2: [Entry]?) {
    guard e1?.count == e2?.count else {
        return
    }
    
    guard e1.hasValue && e2.hasValue else {
        return
    }
    
    for i in 0..<e1!.count {
        print(e1![i])
        print(e2![i])
        print(e1![i] == e2![i])
    }
    
    print(e1! == e2!)
    print("finished")
}



extension UITableViewCell {
    
    var isChecked: Bool {
        
        let accessoryType = self.accessoryType
        switch accessoryType {
        case .checkmark:
            return true
        case .none:
            return false
        default:
            return false
        }
    }
    
    func checkCell() {
        print("checking cell")
        switch isChecked {
        case true:
            self.accessoryType = .none
        case false:
            self.accessoryType = .checkmark
        }
    }
    
}

//extension Array {
//    
//    func remove(element: Element) {
//        guard let index = self.index(of: element) else {
//            
//        }
//    }
//    
//}

//extension Array where Element: Entry {
//    
//    func loadSavedEntries() -> [Entry]? {
//        
//        guard let savedEntries = getSavedObject(key: .SavedEntries) as? [Entry] else {
//            return nil
//        }
//        
//        return savedEntries
//        
//    }
//    
//}
