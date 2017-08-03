//
//  EditEntryController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-24.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit


class EditEntryController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // *** Views *** //
    var nameTextField: UITextField!
    var coffeeTypeTextField: UITextField!
    var favCoffeeShopTextField: UITextField!
    var commentsTextView: UITextView!
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
        title = entry.hasValue ? "Edit Entry" : "Add Entry"
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.hideKeyboardWhenTappedAround()
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
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
            commentsTextView = (cell as! CSTableViewTextViewCell).textView
//            commentsTextView.sizeToFit()
            commentsTextView.font = UIFont.systemFont(ofSize: 17)
            commentsTextView.text = entry?.comments
            commentsTextView.delegate = self
        }
        
        textField?.delegate = self
        textField?.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
//            return 100
            return UITableViewAutomaticDimension
        }
        return 44
    }
    // *** End TableView Setup *** //
    
    ///Exit editing viewcontroller without saving
    func dismissView() {
        self.dismissKeyboard()
        let animationType: AnimationType? = entry.hasValue ? .fade : .push
        navigationController?.popViewController(animationType: animationType)
    }
    
    ///Saves the entry and any changes made to it
    func save() {
        if entry.hasValue {
            entry?.name = nameTextField.text!
            entry?.coffeeType = coffeeTypeTextField.text!
            entry?.favCoffeeShop = favCoffeeShopTextField.text!
            entry?.comments = commentsTextView.text!
        } else {
            entry = Entry(name: nameTextField.text!, coffeeType: coffeeTypeTextField.text!, favCoffeeShop: favCoffeeShopTextField.text!, comments: commentsTextView.text)
            User.instance.entries.append(entry!)
            let viewController = ViewEntryController()
            viewController.selectedEntry = entry
            navigationController?.viewControllers.insert(viewController, at: 1)
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
    
    func textViewDidChange(_ textView: UITextView) {
//        let fixedWidth = textView.frame.size.width
//        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        var newFrame = textView.frame
//        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//        textView.frame = newFrame;
//        let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! CSTableViewTextViewCell
//        let textViewHeightConstraint = cell.textViewHeightConstraint
//        textViewHeightConstraint.constant = newFrame.size.height
//        cell.height = 44 + newFrame.size.height
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
////        tableView.setContentOffset(CGPoint(x: 0, y: commentsTextView.center.y - 60), animated: true)
//        view.height += 70
//    }
    
}
