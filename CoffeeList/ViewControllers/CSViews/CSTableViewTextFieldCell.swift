//
//  CSTableViewLabelCell.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-07-19.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import CSKit

class CSTableViewTextFieldCell: UITableViewCell {
    
    let textField: UITextField = UITextField()
    
    init(placeholder: String?, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        textField.placeholder = placeholder
        self.addSubview(textField)
        textField.center(in: self)
        textField.width(to: self, multiplier: 0.9)
        textField.height(to: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
