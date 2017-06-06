//
//  EditEntryListController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-17.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

class EditEntryListController: UITableViewController {
    
    var listName: String!
    var list: EntryList?
    var selectedEntries = [Entry]() //Entries that user selects
    
    var entryHandlerDelegate: EntryHandlerViewerDelegate?
    
    //Sets up view controller
    override  func  viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(EditEntryListController.dismissView))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditEntryListController.save))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.title = "Select Entries"
        setUpView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.instance.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addEntryCell", for: indexPath)
        let usedEntry  = User.instance.entries[indexPath.item]
        cell.textLabel?.text = usedEntry.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntry: Entry = User.instance.entries[indexPath.item]
        if let cell = tableView.cellForRow(at: indexPath) {
            if (cell.isChecked) {
                cell.setState(.none)
                guard let index = selectedEntries.index(of: selectedEntry) else { return }
                selectedEntries.remove(at: index)
            } else {
                cell.setState(.checkmark)
                selectedEntries.append(selectedEntry)
            }
            
            self.navigationItem.rightBarButtonItem?.isEnabled = selectedEntries.count == 0 ? false : true
        }
        
    }
    
    func save() {
        
        if list.hasValue {
            list?.entries = selectedEntries
            entryHandlerDelegate?.updateEntryType()
        } else {
            let newList = EntryList(listName: listName, entries: selectedEntries)
            User.instance.entryLists.append(newList)
        }
        User.instance.save(selection: .EntryLists)
        dismissView()
    }
    
    func dismissView() {
        _ = self.navigationController?.popViewController(animated: !list.hasValue)
    }
    
    
    
    func setUpView() {
        //savedEntries = Entries.getFromUserDefaults(withKey: .SavedEntries)
        self.tableView.reloadData()
        guard list.hasValue else {
            return
        }
        
        let entries = list?.entries
        for entry in entries! {
            guard let index = User.instance.entries.index(where: { $0 == entry }) else {
                return
            }
            let path = IndexPath(row: index, section: 0)
            //addEntriesList.selectRow(at: path, animated: true, scrollPosition: .none)
            
            let cell = self.tableView.cellForRow(at: path)
            cell!.setState(.checkmark)
        }
        
    }
    
}
