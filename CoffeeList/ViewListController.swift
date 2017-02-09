//
//  ViewListController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-11-16.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit
import CSKit


class ViewListController: UITableViewController, SegueHandlerType {
    
    enum SegueIdentifier : String {
        case ShowEditSelectedList = "showEditSelectedList"
    }
    
    let S = Singleton.sharedInstance
    var selectedEntryList: EntryList!
    var shouldUpdate = Bool()
    
    @IBOutlet var viewListTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Manage Lists", style: <#T##UIBarButtonItemStyle#>, target: <#T##Any?#>, action: <#T##Selector?#>)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ViewListController.edit))
        self.title = selectedEntryList.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        shouldUpdate = S.shouldUpdate
        
        guard shouldUpdate else {
            return
        }
        
        selectedEntryList = S.selectedEntryList!
        shouldUpdate = false
        S.clearAll()
        viewListTableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard selectedEntryList.entries.hasValue else {
            return 0
        }
        
        return selectedEntryList.entries!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewListCell", for: indexPath)
        let usedEntry = selectedEntryList.entries?[indexPath.item]
        cell.textLabel?.text = usedEntry?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue: segue) {
        case .ShowEditSelectedList:
            let editListController: EditListController = segue.destination as! EditListController
            editListController.isNewList = false
            editListController.list = selectedEntryList
            editListController.selectedEntries = selectedEntryList.entries!
            return
        }
    }
    
    func edit() {
        performSegueWithIdentifier(segueIdentifier: .ShowEditSelectedList, sender: nil)
    }
}
