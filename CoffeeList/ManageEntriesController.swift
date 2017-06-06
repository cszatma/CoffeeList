//
//  ManageEntriesController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-23.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

class ManageEntriesController: UITableViewController, SegueHandler {
    
    typealias SegueIdentifier = EntryHandlerSegueIdentifiers
    
    private var selectedIndex = Int()

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
        return User.instance.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "entryTypeCell", for: indexPath)
            let usedEntry = User.instance.entries[indexPath.item]
            cell.textLabel?.text = usedEntry.name
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell number: \(indexPath.row)")
        selectedIndex = indexPath.row
        performSegue(withIdentifier: .ShowViewEntry, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            User.instance.entries.remove(at: indexPath.row)
            User.instance.save(selection: .Entries)
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
        (segue.destination as! ViewEntryController).selectedEntry = User.instance.entries[selectedIndex]
    }
    
}
