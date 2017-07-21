//
//  EditEntryController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-24.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit


class EditEntryController: UIViewController, UITextFieldDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EditEntryController.dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditEntryController.save))
        saveBarButton = navigationItem.rightBarButtonItem
        saveBarButton?.isEnabled = false
        title = entry.hasValue ? "Add Entry" : "Edit Entry"
        setupView()
        self.hideKeyboardWhenTappedAround()
        for case let textField as UITextField in self.view.subviews {
            textField.delegate = self
            textField.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
        }
    }
    
    func setupView() {
        let topOffset = view.height / 8
        // nameTextField
        view.addSubview(nameTextField)
        nameTextField.centerX(to: view)
        nameTextField.top(to: view, offset: topOffset)
        nameTextField.width(to: view, multiplier: 1/2)
        nameTextField.height(to: view, multiplier: 1/8)
        nameTextField.text = entry?.name
        
        // coffeeTypeTextField
        view.addSubview(coffeeTypeTextField)
        coffeeTypeTextField.centerX(to: view)
        coffeeTypeTextField.topToBottom(of: nameTextField, offset: topOffset)
        coffeeTypeTextField.width(to: nameTextField)
        coffeeTypeTextField.height(to: nameTextField)
        coffeeTypeTextField.text = entry?.coffeeType
        
        // favCoffeeShopTextField
        view.addSubview(favCoffeeShopTextField)
        favCoffeeShopTextField.centerX(to: view)
        favCoffeeShopTextField.topToBottom(of: coffeeTypeTextField, offset: topOffset)
        favCoffeeShopTextField.width(to: nameTextField)
        favCoffeeShopTextField.height(to: nameTextField)
        favCoffeeShopTextField.text = entry?.favCoffeeShop
        
        // commentsTextView
        view.addSubview(commentsTextView)
        commentsTextView.centerX(to: view)
        commentsTextView.topToBottom(of: favCoffeeShopTextField, offset: topOffset)
        commentsTextView.width(to: nameTextField)
        commentsTextView.height(to: nameTextField, multiplier: 2)
        commentsTextView.text = entry?.comments
    }
    
    ///Exit editing viewcontroller without saving
    func dismissView() {
        self.dismissKeyboard()
        navigationController?.popViewController(animated: true)
    }
    
    ///Saves the entry and any changes made to it
    func save() {
        if entry.hasValue {
            entry?.update(name: nameTextField.text!, coffeeType: coffeeTypeTextField.text!, favCoffeeShop: favCoffeeShopTextField.text!, comments: commentsTextView.text)
        } else {
            User.instance.entries.append(Entry(name: nameTextField.text!, coffeeType: coffeeTypeTextField.text!, favCoffeeShop: favCoffeeShopTextField.text!, comments: commentsTextView.text))
        }
        User.instance.save(selection: .Entries)
        entryHandlerDelegate?.updateEntryType()
        dismissView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            coffeeTypeTextField.becomeFirstResponder()
        case coffeeTypeTextField:
            favCoffeeShopTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textChanged(sender: UITextField) {
        if !nameTextField.text!.isEmpty && !coffeeTypeTextField.text!.isEmpty && !favCoffeeShopTextField.text!.isEmpty {
            saveBarButton?.isEnabled = true
        }
        
        if nameTextField.text! == entry?.name && coffeeTypeTextField.text! == entry?.coffeeType && favCoffeeShopTextField.text! == entry?.favCoffeeShop && commentsTextView.text! == entry?.comments {
            saveBarButton?.isEnabled = false
        }
    }
    
    
    // TODO: change textfield height based on number of lines user has - default 1 line, increases with each additional line, decreases with each deleted line
}
