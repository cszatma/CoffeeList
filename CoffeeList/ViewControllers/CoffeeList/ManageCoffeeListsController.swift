//
//  ManageCoffeeListsController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-15.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit
import RealmSwift
import QuickPersist

class ManageCoffeeListsController: UITableViewController {
    
    var coffeeLists = CoffeeLists()
    private var lastIndex: Int?
    
    convenience init() {
        self.init(style: .plain)
        do {
            coffeeLists = try CoffeeList.fetchAll(from: Realm()).sorted()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        title = "Manage Coffee Lists"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CoffeeList.reuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAdd() {
        presentController(index: nil)
    }
    
    func presentController(index: Int?) {
        let viewController: UIViewController
        if let coffeeListIndex = index {
            lastIndex = index
            viewController = ViewCoffeeListController()
            (viewController as! ViewCoffeeListController).coffeeList = coffeeLists[coffeeListIndex]
        } else {
            viewController = EditCoffeeListController()
            (viewController as! EditCoffeeListController).delegate = self
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource methods
extension ManageCoffeeListsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffeeLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return coffeeLists[indexPath.row].cellForTableView(tableView, atIndexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let coffeeListToDelete = coffeeLists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                let op = try RealmOperator()
                try op.write { transaction in
                    try transaction.delete(coffeeListToDelete)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDelegate methods
extension ManageCoffeeListsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentController(index: indexPath.row)
    }
}

extension ManageCoffeeListsController: CoffeeListDelegate {
    func update(newValue: CoffeeList) {
        if let index = lastIndex {
            lastIndex = nil
            let oldCoffeeList = coffeeLists.replace(newElement: newValue, at: index)
            if oldCoffeeList.name == newValue.name {
                return
            }
        } else {
            coffeeLists.append(newValue)
        }
        
        coffeeLists.sort()
        tableView.reloadData()
    }
}

