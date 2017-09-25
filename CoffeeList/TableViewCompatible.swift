//
//  TableViewCompatible.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-08-11.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import UIKit

protocol TableViewCompatible {
    
    static var reuseIdentifier: String { get }
    
    func cellForTableView(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell
    
}
