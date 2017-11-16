//
//  CSTableViewDataSource.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-08-15.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

//import UIKit
//
//class CLTableViewDataSource<T: CLType>: NSObject, UITableViewDataSource {
//    
//    let tableView: UITableView
//    var isEditable = true
//    
//    init(tableView: UITableView) {
//        self.tableView = tableView
//        super.init()
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: T.reuseIdentifier)
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return User.instance.count(of: T.userDataType)
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let array: [T] = T.userDataType == .Entries ? User.instance.entries as! [T] : User.instance.coffeeLists as! [T]
//        return array[indexPath.row].cellForTableView(tableView, atIndexPath: indexPath)
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            User.instance.removeElement(from: T.userDataType, at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return isEditable
//    }
//    
//}

