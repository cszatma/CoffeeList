//
//  EditEntryController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-24.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit


class EditEntryController: UITableViewController, UITextFieldDelegate {
    
    // *** Views *** //
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Name"
        return textField
    }()
    
    let coffeeTypeTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Coffee Type"
        return textField
    }()
    
    let favCoffeeShopTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Favourite Coffee Shop"
        return textField
    }()
    
    let commentsTextView: UITextView = {
        let textView = UITextView()
        textView.setBorder(width: 2, color: .gray)
        return textView
    }()
    // *** End Views *** //
    
    var entry: Entry?
    weak var saveBarButton: UIBarButtonItem?
    var entryHandlerDelegate: EntryHandlerViewerDelegate?
    
    fileprivate let cellId = "entryPropertyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EditEntryController.dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditEntryController.save))
        saveBarButton = navigationItem.rightBarButtonItem
        saveBarButton?.isEnabled = false
        title = entry.hasValue ? "Add Entry" : "Edit Entry"
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.hideKeyboardWhenTappedAround()
        for case let textField as UITextField in self.view.subviews {
            textField.delegate = self
            textField.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
        }
        tableView.allowsSelection = false
    }
    
    // *** TableView Setup *** //
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 3 {
            cell = CSTableViewTextViewCell(labelText: "Comments", reuseIdentifier: nil)
//            (cell as! CSTableViewTextViewCell).textView.sizeToFit()
            (cell as! CSTableViewTextViewCell).textView.backgroundColor = .red
            (cell as! CSTableViewTextViewCell).textView.text = "TEST"
            (cell as! CSTableViewTextViewCell).textView.font = UIFont.systemFont(ofSize: 17)
        } else {
            cell = CSTableViewTextFieldCell(placeholder: "Enter Text", reuseIdentifier: nil)
            (cell as! CSTableViewTextFieldCell).textField.delegate = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 100
        }
        return 44
    }
    // *** End TableView Setup *** //
    
    ///Exit editing viewcontroller without saving
    func dismissView() {
        self.dismissKeyboard()
        navigationController?.popViewController(animated: true)
    }
    
    ///Saves the entry and any changes made to it
    func save() {
        if entry.hasValue {
            entry?.name = nameTextField.text!
            entry?.coffeeType = coffeeTypeTextField.text!
            entry?.favCoffeeShop = favCoffeeShopTextField.text!
            entry?.comments = commentsTextView.text!
        } else {
            User.instance.entries.append(Entry(name: nameTextField.text!, coffeeType: coffeeTypeTextField.text!, favCoffeeShop: favCoffeeShopTextField.text!, comments: commentsTextView.text))
        }
        User.instance.save(selection: .Entries)
        entryHandlerDelegate?.updateEntryType()
        dismissView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField {
//        case nameTextField:
//            coffeeTypeTextField.becomeFirstResponder()
//        case coffeeTypeTextField:
//            favCoffeeShopTextField.becomeFirstResponder()
//        default:
//            textField.resignFirstResponder()
//        }
        print(textField.superview)
        return true
    }
    
    func textChanged(sender: UITextField) {
        print("Changed")
        if !nameTextField.text!.isEmpty && !coffeeTypeTextField.text!.isEmpty && !favCoffeeShopTextField.text!.isEmpty {
            saveBarButton?.isEnabled = true
        }
        
        if nameTextField.text! == entry?.name && coffeeTypeTextField.text! == entry?.coffeeType && favCoffeeShopTextField.text! == entry?.favCoffeeShop && commentsTextView.text! == entry?.comments {
            saveBarButton?.isEnabled = false
        }
    }
    
    
    // TODO: change textfield height based on number of lines user has - default 1 line, increases with each additional line, decreases with each deleted line
}
