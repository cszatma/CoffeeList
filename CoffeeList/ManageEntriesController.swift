//
//  ManageEntriesController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-23.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

class ManageEntriesController: UITableViewController, CLTypeViewerDelegate {

    var dataSource: CLTableViewDataSource<Entry>!

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = CLTableViewDataSource(tableView: tableView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(ManageEntriesController.back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ManageEntriesController.handleAddEntry))
        title = "Manage Entries"
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentController(index: indexPath.row)
    }

    func handleAddEntry() {
        presentController(index: nil)
    }

    func presentController(index: Int?) {
        let viewController: UIViewController
        if let entryIndex = index {
            viewController = ViewEntryController()
            (viewController as! ViewEntryController).selectedEntry = User.instance.entries[entryIndex]
        } else {
            viewController = EditEntryController()
            (viewController as! EditEntryController).delegate = self
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    func updateEntryType() {
        tableView.reloadData()
    }

}

//class ManageEntriesController: UITableViewController, CLTypeViewerDelegate {
//    
//    fileprivate let cellId = "entryTypeCell"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(ManageEntriesController.back))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ManageEntriesController.handleAddEntry))
//        title = "Manage Entries"
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
//        tableView.tableFooterView = UIView(frame: CGRect.zero)
//    }
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return User.instance.entries.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
//            cell.textLabel?.text = User.instance.entries[indexPath.row].name
//            return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presentController(index: indexPath.row)
//    }
//    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            User.instance.removeElement(from: .Entries, at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//    
//    func handleAddEntry() {
//        presentController(index: nil)
//    }
//    
//    func presentController(index: Int?) {
//        let viewController: UIViewController
//        if let entryIndex = index {
//            viewController = ViewEntryController()
//            (viewController as! ViewEntryController).selectedEntry = User.instance.entries[entryIndex]
//        } else {
//            viewController = EditEntryController()
//            (viewController as! EditEntryController).delegate = self
//        }
//        navigationController?.pushViewController(viewController, animated: true)
//    }
//    
//    func updateEntryType() {
//        tableView.reloadData()
//    }
//    
//}
