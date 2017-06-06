//
//  Extensions.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-06.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit


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

extension Array: UserDefaultsHandler {
    public typealias dataKey = UserDefaultsKeys
}
