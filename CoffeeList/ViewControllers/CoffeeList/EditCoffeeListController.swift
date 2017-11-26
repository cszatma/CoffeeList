//
//  EditCoffeeListController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-17.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import SwiftySweetness
import RealmSwift

class EditCoffeeListController: UITableViewController {

    // *** Views *** //
    var nameTextField: UITextField!
    var notesTextView: UITextView!
    // *** End Views *** //

    var coffeeList: CoffeeList?
    var selectedEntries = Entries() //Entries that user selects
    weak var saveBarButton: UIBarButtonItem?
    weak var delegate: CoffeeListDelegate?
    private var propertyStatus = (false, false, false)
    private var cellId = "listPropertyCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        saveBarButton = navigationItem.rightBarButtonItem
        saveBarButton?.isEnabled = false
        title = coffeeList.hasValue ? "Edit Entry" : "Add Entry"
        hideKeyboardWhenTappedAround(cancelsTouches: false)
        selectedEntries = coffeeList.hasValue ? coffeeList!.entries : []
        propertyStatus.2 = coffeeList.hasValue ? false : true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsSelection = true
        tableView.reloadData()
    }

    @objc func dismissView() {
        dismissKeyboard()
        let animationType: AnimationType = coffeeList.hasValue ? .fade : .push
        navigationController?.popViewController(animationType: animationType)
    }

    func setupTableView() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    @objc func save() {
        let listToSave = CoffeeList(listName: nameTextField.text!.trimmed, entries: selectedEntries, notes: notesTextView.text, id: coffeeList?.id ?? UUID().uuidString)

        if coffeeList == nil {
            let viewController = ViewCoffeeListController()
            viewController.coffeeList = listToSave
            navigationController?.viewControllers.insert(viewController, at: 1)
        }

        do {
            try listToSave.save(to: Realm(), update: true)
        } catch let error {
            print(error.localizedDescription)
        }

        delegate?.update(newValue: listToSave)
        dismissView()
    }

    @objc func textChanged(sender: UITextField) {
        // Make sure textField isn't empty and that text isn't equal to list property.
        guard sender == nameTextField else { return }
            propertyStatus.0 = coffeeList.hasValue ? nameTextField.text! != coffeeList?.name && !nameTextField.text!.isEmpty : !nameTextField.text!.isEmpty

        checkChanges()
    }

    func checkChanges() {
        if coffeeList.hasValue {
            saveBarButton?.isEnabled = propertyStatus == (false, false, false) ? false : true
        } else {
            saveBarButton?.isEnabled = propertyStatus == (true, true, true) ? true : false
        }
    }
}

// MARK: - UITableViewDataSource methods
extension EditCoffeeListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        switch indexPath.row {
        case 0:
            cell = CSTableViewTextFieldCell(placeholder: "Name", reuseIdentifier: cellId)
            nameTextField = (cell as! CSTableViewTextFieldCell).textField
            nameTextField.text = coffeeList?.name
            nameTextField?.delegate = self
            nameTextField?.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
        case 1:
            //cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
            cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            cell.textLabel?.text = "Select Entries"
            cell.accessoryType = .disclosureIndicator
        default:
            cell = CSTableViewTextViewCell(labelText: "Comments", reuseIdentifier: cellId)
            notesTextView = (cell as! CSTableViewTextViewCell).textView
            notesTextView.font = UIFont.systemFont(ofSize: 17)
            notesTextView.text = coffeeList?.notes
            notesTextView.delegate = self
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return UITableViewAutomaticDimension
        }
        return 44
    }
}

// MARK: - UITableViewDelegate methods
extension EditCoffeeListController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let viewController = SelectEntriesController()
            viewController.delegate = self
            viewController.selectedEntries = selectedEntries
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension EditCoffeeListController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditCoffeeListController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))

        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            textView.scrollRangeToVisible(NSRange(location: textView.text.count-1, length: 0))
            //textView.scrollRangeToVisible(NSMakeRange(textView.text.characters.count-1, 0))
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            tableView.scrollToRow(at: IndexPath(row: 2, section: 0), at: .bottom, animated: false)
        }

        propertyStatus.2 = notesTextView.text != coffeeList?.notes

        checkChanges()
    }
}

extension EditCoffeeListController: TransferEntriesDelegate {
    func transfer(entries: Entries) {
        selectedEntries = entries
        propertyStatus.1 = selectedEntries.isEmpty ? false : true
    }
}
