//
//  SelectEntriesController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-10-09.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import UIKit
import RealmSwift

class SelectEntriesController: UITableViewController {
    
    var entries = Entries()
    var selectedEntries = Entries()
    weak var delegate: TransferEntriesDelegate?
    
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
        title = "Select Entries"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Entry.reuseIdentifier)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            delegate?.transfer(entries: selectedEntries)
        }
    }
}

// MARK: - UITableViewDataSource methods
extension SelectEntriesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = entries[indexPath.row].cellForTableView(tableView, atIndexPath: indexPath)
        if selectedEntries.contains(entries[indexPath.row]) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
}

// MARK: - UITableViewDelegate methods
extension SelectEntriesController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntry = entries[indexPath.item]
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        if cell.isChecked {
            cell.setState(.none)
            guard let index = selectedEntries.index(of: selectedEntry) else { return }
            selectedEntries.remove(at: index)
        } else {
            cell.setState(.checkmark)
            selectedEntries.append(selectedEntry)
        }
    }
}
