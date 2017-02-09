//
//  ViewController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-19.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit
import CSKit


class ViewController: UIViewController, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case ShowManageEntries = "showManageEntries"
        case ShowManageLists = "showManageLists"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var john: Entry? = Entry(name: "john", coffeeType: "DD", favCoffeeShop: "Tims", comments: nil)
        var john2: Entry? = Entry(name: "john", coffeeType: "DD", favCoffeeShop: "Tims", comments: nil)
        var eddy = Entry(name: "eddy", coffeeType: "2C", favCoffeeShop: "Tims", comments: nil)
        let e1:[Entry] = [john2!, eddy]
        let e2:[Entry] = [john2!, eddy]
        print(e1 == e2)
//        print(john == john2)
        let list1: EntryList? = EntryList(listName: "List1", entries: [john!, john2!, eddy])
        let list2: EntryList? = EntryList(listName: "List1", entries: [john!, john2!, eddy])
        let list3: EntryList? = EntryList(listName: "List3", entries: [eddy])
        let arr1: [EntryList]? = [list1!, list2!]
//        let arr2: [EntryList]? = [list1!, list2!]
//        print(arr1 == arr2)
//        print(list1 == list2)
        print(list3 == arr1![1])
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnManageEntries_Touch(_ sender: AnyObject) {
        performSegueWithIdentifier(segueIdentifier: .ShowManageEntries, sender: nil)
    }

    @IBAction func btnManageLists_Touch(_ sender: AnyObject) {
        performSegueWithIdentifier(segueIdentifier: .ShowManageLists, sender: nil)
    }

    
}



