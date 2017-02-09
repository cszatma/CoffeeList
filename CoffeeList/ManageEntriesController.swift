//
//  ManageEntriesController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-23.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit
import CSKit

class ManageEntriesController: UITableViewController, SegueHandlerType, DataSaver {
    
    enum SegueIdentifier: String {
        case ShowEditEntry = "showEditEntry"
        case ShowViewEntry = "showViewEntry"
    }
    
    enum dataKey: String {
        case SavedEntries = "savedEntries"
    }
    
    var savedEntries: [Entry]?
    var selectedEntry = Int()
    
    //var newEntry = Bool()
    
    @IBOutlet var entriesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(ManageEntriesController.back))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ManageEntriesController.add))
        self.title = "Manage Entries"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        entriesTableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadEntries()
        //savedEntries.update
        
        guard savedEntries != nil else {
            return 0
        }
        return savedEntries!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
            let usedEntry = savedEntries?[indexPath.item]
            cell.textLabel?.text = usedEntry?.name
            return cell
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell number: \(indexPath.row)")
        selectedEntry = indexPath.row
        performSegueWithIdentifier(segueIdentifier: .ShowViewEntry, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let selectedEntry = savedEntries?[indexPath.item]
            selectedEntry?.removeFrom(entries: savedEntries!)
            entriesTableView.reloadData()
            
        }
    }
    
    func loadEntries() {
        guard let loadedEntries = getSavedObject(key: .SavedEntries) as? [Entry] else {
            return
        }
        savedEntries = sortEntries(entries: loadedEntries)
    }
    
    func add() {
        performSegueWithIdentifier(segueIdentifier: .ShowEditEntry, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue: segue) {
        case .ShowEditEntry:
            let editEntryController: EditEntryController = segue.destination as! EditEntryController
            editEntryController.isNewEntry = true
        case .ShowViewEntry:
            let viewEntryController: ViewEntryController = segue.destination as! ViewEntryController
            viewEntryController.selectedEntry = savedEntries?[selectedEntry]
           return
        }
        
        
    }
    
}
