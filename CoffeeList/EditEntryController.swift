//
//  EditEntryController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-24.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit


class EditEntryController: UIViewController, UITextFieldDelegate {
    
    var entry: Entry?
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtCoffeeType: UITextField!
    @IBOutlet var txtFavCoffeeShop: UITextField!
    @IBOutlet var txtComments: UITextView!
    
    weak var saveBarButton: UIBarButtonItem?
    
    var entryHandlerDelegate: EntryHandlerViewerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EditEntryController.dismissView))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditEntryController.save))
        saveBarButton = self.navigationItem.rightBarButtonItem
        saveBarButton?.isEnabled = false
        self.title = entry.hasValue ? "Add Entry" : "Edit Entry"
        setUpView()
        self.hideKeyboardWhenTappedAround()
        for case let textField as UITextField in self.view.subviews {
            textField.delegate = self
            textField.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
        }
    }
    
    ///Exit editing viewcontroller without saving
    func dismissView() {
        self.dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    ///Saves the entry and any changes made to it
    func save() {
        if entry.hasValue {
            entry?.name = txtName.text!
            entry?.coffeeType = txtCoffeeType.text!
            entry?.favCoffeeShop = txtFavCoffeeShop.text!
            entry?.comments = txtComments.text!
            entryHandlerDelegate?.updateEntryType()
        } else {
            let newEntry = Entry(name: txtName.text!, coffeeType: txtCoffeeType.text!, favCoffeeShop: txtFavCoffeeShop.text!, comments: txtComments.text)
            User.instance.entries.append(newEntry)
        }
        User.instance.save(selection: .Entries)
        dismissView()
        
    }
    
    func setUpView() {
        guard entry.hasValue else {
            return
        }
        txtName.text = entry?.name
        txtCoffeeType.text = entry?.coffeeType
        txtFavCoffeeShop.text = entry?.favCoffeeShop
        txtComments.text = entry?.comments
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textChanged(sender: UITextField) {
        if !txtName.text!.isEmpty && !txtCoffeeType.text!.isEmpty && !txtFavCoffeeShop.text!.isEmpty {
            saveBarButton?.isEnabled = true
        }
        
        if txtName.text! == entry?.name && txtCoffeeType.text! == entry?.coffeeType && txtFavCoffeeShop.text! == entry?.favCoffeeShop && txtComments.text! == entry?.comments {
            saveBarButton?.isEnabled = false
        }
    }
    
    
    // TODO: change textfield height based on number of lines user has - default 1 line, increases with each additional line, decreases with each deleted line
}
