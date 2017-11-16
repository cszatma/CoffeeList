//
//  Enums.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-03-12.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import Foundation

enum AnimationType: String {
    case push = "push"
    case fade = "fade"
}

enum PersistableError: Error {
    case unableToFetch
    case unableToDelete
}
