//
//  EntryHandlerViewerDelegate.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-03-11.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import CSKit

protocol EntryHandlerViewerDelegate {
    func updateEntryType<T: EntryHandler>(with entryHandler: T)
}