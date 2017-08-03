//
//  CSTableViewTextViewCell.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-07-21.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import CSKit
import TinyConstraints

class CSTableViewTextViewCell: UITableViewCell {
    
    let label: UILabel = UILabel()
    let textView: UITextView = UITextView()
    var textViewHeightConstraint = Constraint()
    
    init(labelText: String?, reuseIdentifier: String?, textViewHeight: CGFloat = 56) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        label.text = labelText
        self.addSubview(label)
        self.addSubview(textView)
        label.centerX(to: self)
        label.top(to: self)
        label.width(to: self, multiplier: 0.9)
        label.height(44)
        textView.centerX(to: self)
        textView.topToBottom(of: label)
        textView.bottom(to: self)
        textView.width(to: self, multiplier: 0.9)
//        textViewHeightConstraint = textView.height(textViewHeight)
        textView.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
