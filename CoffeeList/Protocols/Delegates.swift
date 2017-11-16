//
//  CLTypeViewerDelegate.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-03-11.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import Foundation

protocol EntryDelegate: class {
    func update(newValue: Entry)
}

protocol CoffeeListDelegate: class {
    func update(newValue: CoffeeList)
}

protocol TransferEntriesDelegate: class {
    func transfer(entries: Entries)
}
