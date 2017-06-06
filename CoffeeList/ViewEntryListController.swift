//
//  ViewEntryListController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-11-16.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

class ViewEntryListController: UITableViewController, SegueHandler, EntryHandlerViewerDelegate {
    
    enum SegueIdentifier : String {
        case ShowEditSelectedList = "showEditSelectedList"
    }
    
    var selectedEntryList: EntryList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Manage Lists", style: <#T##UIBarButtonItemStyle#>, target: <#T##Any?#>, action: <#T##Selector?#>)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ViewEntryListController.edit))
        self.title = selectedEntryList.name
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedEntryList.entries?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewListCell", for: indexPath)
        let usedEntry = selectedEntryList.entries?[indexPath.item]
        cell.textLabel?.text = usedEntry?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(forSegue: segue) {
        case .ShowEditSelectedList:
            let editListController: EditEntryListController = segue.destination as! EditEntryListController
            editListController.listName = selectedEntryList.name
            editListController.list = selectedEntryList
            editListController.selectedEntries = selectedEntryList.entries!
            editListController.entryHandlerDelegate = self
            return
        }
    }
    
    func edit() {
        performSegue(withIdentifier: .ShowEditSelectedList, sender: nil)
    }
    
    func updateEntryType() {
        self.tableView.reloadData()
    }
}
