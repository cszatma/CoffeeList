//
//  Protocols.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-21.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

protocol EditController {
    func save()
    func setUpView()
}

extension EditController where Self: UIViewController {
    
}
