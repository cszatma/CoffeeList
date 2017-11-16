//
//  CSTableViewTextViewCell.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-07-21.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import TinyConstraints

class CSTableViewTextViewCell: UITableViewCell {

    let label = UILabel()
    let textView = UITextView()

    convenience init(labelText: String?, reuseIdentifier: String?, textViewHeight: CGFloat = 56) {
        self.init(style: .default, reuseIdentifier: reuseIdentifier)
        label.text = labelText
        addSubview(label)
        addSubview(textView)
        label.centerXToSuperview()
        label.topToSuperview()
        label.widthToSuperview(multiplier: 0.9)
        label.height(44)
        textView.centerXToSuperview()
        textView.topToBottom(of: label)
        textView.bottomToSuperview()
        textView.widthToSuperview(multiplier: 0.9)
        textView.isScrollEnabled = false
    }
}
