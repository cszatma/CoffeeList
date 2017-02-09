//
//  EditListController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-17.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit
import CSKit

class EditListController: UITableViewController, DataSaver {
    
    enum dataKey: String {
        case SavedLists = "savedLists"
        case SavedEntries = "savedEntries"
    }
    
    var isNewList = Bool() //Determines whether the user is creating a new list or editing an existing one
    var list: EntryList?
    var savedEntries: [Entry]?
    var selectedEntries = [Entry]() //Entries that user selects
    
    @IBOutlet var addEntriesList: UITableView!
    
    //Sets up view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(EditListController.cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditListController.save))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.title = "Save"
        setUpView(isNewList: isNewList)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadEntries()
        guard savedEntries != nil else {
            return 0
        }
        return savedEntries!.count
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
            //cell.accessoryType = .checkmark
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
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            cell.accessoryType = .none
//        }
//        selectedEntries.remove(at: indexPath.item)
//    }
    
    func save() {
        //selectedEntries = sortEntries(entries: selectedEntries)
        let newList = EntryList(listName: list!.name, entries: selectedEntries)
        
        guard isNewList else {
            newList.updateEntryList(originalEntryList: list!)
            Singleton.sharedInstance.shouldUpdate = true
            Singleton.sharedInstance.selectedEntryList = newList
            return
        }
        
        newList.saveEntryList()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func cancel() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func loadEntries() {
//        guard let loadedEntries = getSavedObject(key: .SavedEntries) as? [Entry] else {
//            return
//        }
//        savedEntries = sortEntries(entries: loadedEntries)
        //savedEntries = getSavedObject(key: .SavedEntries) as? [Entry]
    }
    
    func setUpView(isNewList: Bool) {
        guard !(isNewList) else {
            return
        }
        print("editing")
        let entries = list?.entries
        print(savedEntries)
        for entry in entries! {
            guard let index = savedEntries?.index(of: entry) else {
                return
            }
            print("selecting")
            let path = IndexPath(row: index, section: 0)
            //addEntriesList.selectRow(at: path, animated: true, scrollPosition: .none)
            let cell = addEntriesList.cellForRow(at: path)
            cell?.checkCell()
        }
        
    }

    
}
