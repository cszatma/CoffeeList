//
//  ManageEntryHandlerController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-03-11.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import CSKit

class ManageEntryHandlerController<T: EntryHandler>: UITableViewController, SegueHandler {
    
    //Used to conform to the SegueHandlerType protocol.
    typealias SegueIdentifier = EntryHandlerSegueIdentifiers
    
    ///Array containing all the saved Entries or EntryLists
    private var savedEntryTypes: [T]?
    
    ///Stores the index of the cell the user selects
    private lazy var selectedIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(ManageEntryHandlerController.back))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ManageEntryHandlerController.add))
        self.title = T.self is Entry.Type ? "Manage Entries" : "Manage Lists"
    }
    
    //Reloads the savedEntryTypes array to update thcse tableview with any changes.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    /* Following methods are for setting up the tableview */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedEntryTypes = [T].getFromUserDefaults(withKey: getDataKey(ofType: T.self))
        return savedEntryTypes?.count ?? 0
    }
    
    //Load all the cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryTypeCell", for: indexPath)
        cell.textLabel?.text = savedEntryTypes?[indexPath.row].name
        return cell
    }
    
    ///Initiates the segue to view the selected Entry or EntryList when a cell is tapped.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let identifier = T.self is Entry.Type ? SegueIdentifier.ShowViewEntry : SegueIdentifier.ShowViewEntryList
        performSegue(withIdentifier: identifier, sender: nil)
    }
    
    ///Makes the tableview cells editable. Required in order to delete them.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if T.self is Entry.Type {
                User.instance.entries.remove(at: indexPath.row)
                User.instance.save(selection: .Entries)
            } else {
                User.instance.entryLists.remove(at: indexPath.row)
                User.instance.save(selection: .EntryLists)
            }
            
            self.tableView.reloadData()
        }
    }
    
    func add() {
        let identifier = T.self is Entry.Type ? SegueIdentifier.ShowEditEntry : SegueIdentifier.ShowEditEntryList
        performSegue(withIdentifier: identifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(forSegue: segue) {
        case .ShowEditEntry:
            return
        case .ShowViewEntry:
            (segue.destination as! ViewEntryController).selectedEntry = savedEntryTypes?[selectedIndex] as! Entry
        case .ShowEditEntryList:
            return
        case .ShowViewEntryList:
            (segue.destination as! ViewEntryListController).selectedEntryList = savedEntryTypes?[selectedIndex] as! EntryList
        }
    }
    
}
