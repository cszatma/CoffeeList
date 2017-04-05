//
//  EditEntryListController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-17.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

class EditEntryListController: UITableViewController, EditController {
    
    var listName: String!
    var list: EntryList?
    var savedEntries: [Entry]?
    var selectedEntries = [Entry]() //Entries that user selects
    
    var entryHandlerDelegate: EntryHandlerViewerDelegate?
    
    //Sets up view controller
    override  func  viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(EditEntryListController.cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditEntryListController.save))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.title = "Select Entries"
        setUpView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedEntries = Entries.getFromUserDefaults(withKey: .SavedEntries)
        return savedEntries?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addEntryCell", for: indexPath)
        let usedEntry  = savedEntries?[indexPath.item]
        cell.textLabel?.text = usedEntry?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntry: Entry = (savedEntries?[indexPath.item])!
        if let cell = tableView.cellForRow(at: indexPath) {
            guard !(cell.isChecked) else {
                cell.accessoryType = .none
                cell.backgroundColor = UIColor.white
                guard let index = selectedEntries.index(of: selectedEntry) else {
                    return
                }
                
                selectedEntries.remove(at: index)
                if selectedEntries.count == 0 {
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
                return
            }
            
            cell.accessoryType = .checkmark
            cell.backgroundColor = #colorLiteral(red: 0.2674255417, green: 1, blue: 0.3940180105, alpha: 1)
            if selectedEntries.count == 0 {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            selectedEntries.append(selectedEntry)
        }
        
    }
    
    func save() {
        let newList = EntryList(listName: listName, entries: selectedEntries)
        
        guard !list.hasValue else {
            newList.update(original: list!)
            entryHandlerDelegate?.updateEntryType(with: newList)
            return
        }
        
        newList.save()
        cancel()
    }
    
    func cancel() {
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
            guard let index = savedEntries?.index(where: { $0 == entry }) else {
                return
            }
            print("selecting")
            let path = IndexPath(row: index, section: 0)
            //addEntriesList.selectRow(at: path, animated: true, scrollPosition: .none)
            
            let cell = self.tableView.cellForRow(at: path)
            cell!.checkCell()
        }
        
    }
    
}
