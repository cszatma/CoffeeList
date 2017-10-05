//
//  EditEntryController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-24.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit

typealias PropertyStatus = (Bool, Bool, Bool, Bool)

class EditEntryController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // *** Views *** //
    var nameTextField: UITextField!
    var coffeeTypeTextField: UITextField!
    var favCoffeeShopTextField: UITextField!
    var notesTextView: UITextView!
    // *** End Views *** //
    
    var entry: Entry?
    weak var saveBarButton: UIBarButtonItem?
    var delegate: CLTypeViewerDelegate?
    private var propertyStatus: PropertyStatus = (false, false, false, false)
    private let cellId = "entryPropertyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tableview
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(CSTableViewTextFieldCell.self, forCellReuseIdentifier: cellId)
        
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EditEntryController.dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditEntryController.save))
        saveBarButton = navigationItem.rightBarButtonItem
        saveBarButton?.isEnabled = false
        title = entry.hasValue ? "Edit Entry" : "Add Entry"
        self.hideKeyboardWhenTappedAround()
        propertyStatus.3 = entry.hasValue ? false : true
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
        var textField: UITextField?
        
        switch indexPath.row {
        case 0:
            cell = CSTableViewTextFieldCell(placeholder: "Name", reuseIdentifier: cellId)
            nameTextField = (cell as! CSTableViewTextFieldCell).textField
            textField = nameTextField
            nameTextField.text = entry?.name
        case 1:
            cell = CSTableViewTextFieldCell(placeholder: "Coffee Type", reuseIdentifier: cellId)
            coffeeTypeTextField = (cell as! CSTableViewTextFieldCell).textField
            textField = coffeeTypeTextField
            coffeeTypeTextField.text = entry?.coffeeType
        case 2:
            cell = CSTableViewTextFieldCell(placeholder: "Favourite Coffee Shop", reuseIdentifier: cellId)
            favCoffeeShopTextField = (cell as! CSTableViewTextFieldCell).textField
            textField = favCoffeeShopTextField
            favCoffeeShopTextField.text = entry?.favCoffeeShop
        default:
            cell = CSTableViewTextViewCell(labelText: "Comments", reuseIdentifier: nil)
            notesTextView = (cell as! CSTableViewTextViewCell).textView
            notesTextView.font = UIFont.systemFont(ofSize: 17)
            notesTextView.text = entry?.notes
            notesTextView.delegate = self
        }
        
        textField?.delegate = self
        textField?.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return UITableViewAutomaticDimension
        }
        return 44
    }
    // *** End TableView Setup *** //
    
    ///Exit editing viewcontroller without saving
    @objc func dismissView() {
        self.dismissKeyboard()
        let animationType: AnimationType? = entry.hasValue ? .fade : .push
        navigationController?.popViewController(animationType: animationType)
    }
    
    ///Saves the entry and any changes made to it
    @objc func save() {
        if entry.hasValue {
            entry?.update(name: nameTextField.trimmedText, coffeeType: coffeeTypeTextField.trimmedText, favCoffeeShop: favCoffeeShopTextField.trimmedText, notes: notesTextView.text)
        } else {
            entry = Entry(name: nameTextField.trimmedText, coffeeType: coffeeTypeTextField.trimmedText, favCoffeeShop: favCoffeeShopTextField.trimmedText, notes: notesTextView.text)
            User.instance.entries.append(entry!)
            let viewController = ViewEntryController()
            viewController.selectedEntry = entry
            navigationController?.viewControllers.insert(viewController, at: 1)
        }
        User.instance.save(selection: .Entries)
        delegate?.updateEntryType()
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
    
    @objc func textChanged(sender: UITextField) {
        // Make sure textField isn't empty and that text isn't equal to entry property.
        switch sender {
        case nameTextField:
            propertyStatus.0 = entry.hasValue ? nameTextField.text! != entry?.name && !nameTextField.text!.isEmpty : !nameTextField.text!.isEmpty
        case coffeeTypeTextField:
            propertyStatus.1 = entry.hasValue ? coffeeTypeTextField.text! != entry?.coffeeType && !coffeeTypeTextField.text!.isEmpty : !coffeeTypeTextField.text!.isEmpty
        default:
            propertyStatus.2 = entry.hasValue ? favCoffeeShopTextField.text! != entry?.favCoffeeShop && !favCoffeeShopTextField.text!.isEmpty : !favCoffeeShopTextField.text!.isEmpty
        }
        
        checkChanges()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            textView.scrollRangeToVisible(NSMakeRange(textView.text.characters.count-1, 0))
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            tableView.scrollToRow(at: IndexPath(row: 3, section: 0), at: .bottom, animated: false)
        }
        
        propertyStatus.3 = notesTextView.text != entry?.notes
        
        checkChanges()
    }
    
    func checkChanges() {
        if entry.hasValue {
            saveBarButton?.isEnabled = propertyStatus == (false, false, false, false) ? false : true
        } else {
            saveBarButton?.isEnabled = propertyStatus == (true, true, true, true) ? true : false
        }
    }

}
