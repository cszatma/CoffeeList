//
//  ManageEntriesController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-23.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit
import RealmSwift
import QuickPersist

class ManageEntriesController: UITableViewController {

    var entries = Entries()
    private var lastIndex: Int?
    
    convenience init() {
        self.init(style: .plain)
        do {
            entries = try Entry.fetchAll(from: Realm()).sorted()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddEntry))
        title = "Manage Entries"
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Entry.reuseIdentifier)
        // navigationController.toolbar
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }

    @objc func handleAddEntry() {
        presentController(index: nil)
    }

    func presentController(index: Int?) {
        let viewController: UIViewController
        if let entryIndex = index {
            lastIndex = index
            viewController = ViewEntryController()
            (viewController as! ViewEntryController).entry = entries[entryIndex]
        } else {
            viewController = EditEntryController()
            (viewController as! EditEntryController).delegate = self
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource methods
extension ManageEntriesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return entries[indexPath.row].cellForTableView(tableView, atIndexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entryToDelete = entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                let op = try RealmOperator()
                try op.write{ transaction in
                    try transaction.delete(entryToDelete)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDelegate methods
extension ManageEntriesController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentController(index: indexPath.row)
    }
}

extension ManageEntriesController: EntryDelegate {
    func update(newValue: Entry) {
        if let index = lastIndex {
            lastIndex = nil
            let oldEntry = entries.replace(newElement: newValue, at: index)
            if oldEntry.name == newValue.name {
                return
            }
        } else {
            entries.append(newValue)
        }
        
        entries.sort()
        tableView.reloadData()
    }
}
