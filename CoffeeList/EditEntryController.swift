//
//  EditEntryController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-24.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit


class EditEntryController: UIViewController, UITextFieldDelegate {
    
    var isNewEntry = Bool()
    var entry: Entry?
    
    @IBOutlet var txtName: UITextField!
    
    @IBOutlet var txtCoffeeType: UITextField!
    
    @IBOutlet var txtFavCoffeeShop: UITextField!
    
    @IBOutlet var txtComments: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(isNewEntry)
        //self.navigationItem.backBarButtonItem?.title = "Cancel"
        //self.navigationController?.navigationItem.backBarButtonItem?.title = "Cancel"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EditEntryController.cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditEntryController.save))
        if isNewEntry == true {
            self.title = "Add Entry"
        } else {
            self.title = "Edit Entry"
        }
        setUpView(newEntry: isNewEntry)
        self.hideKeyboardWhenTappedAround()
        self.txtName.delegate = self
        self.txtCoffeeType.delegate = self
        self.txtFavCoffeeShop.delegate = self
        print(txtComments.text)
        print(txtName.text)
    }
    
    
    ///Exit editing viewcontroller without saving
    func cancel() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    ///Saves the entry and any changes made to it
    func save() {
        guard checkInputs() == true else {
            checkIssue()
            return
        }
        let newEntry = Entry(name: txtName.text!, coffeeType: txtCoffeeType.text!, favCoffeeShop: txtFavCoffeeShop.text!, comments: txtComments.text)
        print(txtComments.text)
        print(newEntry.comments)
        if isNewEntry == true {
            newEntry.saveEntry()
        } else {
            newEntry.updateEntry(originalEntry: entry!)
            Singleton.sharedInstance.shouldUpdate = true
            Singleton.sharedInstance.selectedEntry = newEntry
        }
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func setUpView(newEntry: Bool) {
        txtName.placeholder = "Name"
        txtCoffeeType.placeholder = "Coffee Type"
        txtFavCoffeeShop.placeholder = "Favorite Coffee Shop"
        guard newEntry == false else {
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
    
    func checkIssue() {
        var message = String()
        if txtName.text == "" {
            message = "Please enter a name"
        } else if txtCoffeeType.text == "" {
            message = "Please enter coffee type"
        } else if txtFavCoffeeShop.text == "" {
            message = "Please enter favorite coffee shop"
        }
        let alert = UIAlertController(title: "Empty Field", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkInputs() -> Bool {
        var result = Bool()
        if txtName.text != "" && txtCoffeeType.text != "" && txtFavCoffeeShop.text != "" {
            result = true
        }
        return result
    }
    
    //TO DO: change textfield height based on number of lines user has - default 1 line, increases with each additional line, decreases with each deleted line
}
