//
//  CSTableViewLabelCell.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-07-19.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import TinyConstraints

class CSTableViewTextFieldCell: UITableViewCell {

    let textField = UITextField()

    convenience init(placeholder: String?, reuseIdentifier: String?) {
        self.init(style: .default, reuseIdentifier: reuseIdentifier)
        textField.placeholder = placeholder
        addSubview(textField)
        textField.centerInSuperview()
        textField.widthToSuperview(multiplier: 0.9)
        textField.heightToSuperview()
    }
}
