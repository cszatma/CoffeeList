//
//  Array+CoffeeList.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-10-07.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import Foundation

extension Array where Element: CLType {
    var reuseIdentifier: String {
        return Element.reuseIdentifier
    }
}
