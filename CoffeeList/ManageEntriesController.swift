//
//  ManageEntriesController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-23.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

class ManageEntriesController: UITableViewController, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case ShowEditEntry = "showEditEntry"
        case ShowViewEntry = "showViewEntry"
    }
    
    private var savedEntries: [Entry]?
    private var selectedEntry = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(ManageEntriesController.back))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ManageEntriesController.add))
        self.title = "Manage Entries"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedEntries = Entries.getFromUserDefaults(withKey: .SavedEntries)
        
        return savedEntries?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "entryTypeCell", for: indexPath)
            let usedEntry = savedEntries?[indexPath.item]
            cell.textLabel?.text = usedEntry?.name
            return cell
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell number: \(indexPath.row)")
        selectedEntry = indexPath.row
        performSegue(withIdentifier: .ShowViewEntry, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let selectedEntry = savedEntries?[indexPath.item]
            selectedEntry?.delete()
            self.tableView.reloadData()
            
        }
    }
    
    func add() {
        performSegue(withIdentifier: .ShowEditEntry, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segueIdentifier(forSegue: segue) == .ShowViewEntry else {
            return
        }
        (segue.destination as! ViewEntryController).selectedEntry = savedEntries?[selectedEntry]
    }
    
}
