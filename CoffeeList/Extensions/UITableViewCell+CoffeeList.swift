//
//  UITableViewCell+CoffeeList.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-10-07.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    var isChecked: Bool {
        return accessoryType == .checkmark
    }
    
    func setState(_ state: UITableViewCellAccessoryType) {
        switch state {
        case .checkmark:
            self.accessoryType = .checkmark
            self.backgroundColor = #colorLiteral(red: 0.2674255417, green: 1, blue: 0.3940180105, alpha: 1)
        case .none:
            self.accessoryType = .none
            self.backgroundColor = UIColor.white
        default:
            return
        }
    }
    
}
