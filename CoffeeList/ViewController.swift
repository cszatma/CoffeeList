//
//  ViewController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-19.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit


class ViewController: UIViewController, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case ShowManageEntries = "showManageEntries"
        case ShowManageLists = "showManageLists"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let savedEntries = Entries.getFromUserDefaults(withKey: .SavedEntries)
        print(savedEntries)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnManageEntries_Touch(_ sender: AnyObject) {
        performSegue(withIdentifier: .ShowManageEntries, sender: nil)
    }

    @IBAction func btnManageLists_Touch(_ sender: AnyObject) {
        performSegue(withIdentifier: .ShowManageLists, sender: nil)
    }
    
}



