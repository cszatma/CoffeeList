//
//  ManageListsController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-15.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit
import CSKit

class ManageListsController: UITableViewController, DataSaver, SegueHandlerType {
    
    enum dataKey: String {
        case SavedLists = "savedLists"
    }
    
    enum SegueIdentifier: String {
        case ShowEditList = "showEditList"
        case ShowViewList = "showViewList"
    }
    
    enum editingAction: String {
        case NewEntryList = "newEntryList"
        case RenameEntryList = "renameEntryList"
    }
    
    var savedLists: [EntryList]?
    var selectedListIndex = Int()
    var selectedList: EntryList?
    weak var actionToEnable: UIAlertAction?
    
    @IBOutlet var listsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(ManageListsController.back))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ManageListsController.add))
        self.title = "Manage Lists"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        selectedList = nil
        listsTableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadLists()
        guard savedLists != nil else {
            return 0
        }
        return savedLists!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        let usedList = savedLists?[indexPath.item]
        cell.textLabel?.text = usedList?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedListIndex = indexPath.row
        performSegueWithIdentifier(segueIdentifier: .ShowViewList, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            print("List is being deleted")
//            savedLists?.remove(at: indexPath.item)
//            saveData(data: savedLists as AnyObject?, key: .SavedLists)
//            listsTableView.reloadData()
//        } //else if (editingStyle == )
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //rename action
        let rename = UITableViewRowAction(style: .normal, title: "Rename", handler: {_,_ in
            self.showAlert(editingAction: .RenameEntryList, index: indexPath.item)
        })
        
        //delete action
        let delete = UITableViewRowAction(style: .normal, title: "Delete", handler: {_,_ in
            //self.listsTableView.deleteRows(at: [indexPath], with: .none)
            print("List is being deleted")
            let selected = self.savedLists?[indexPath.item]
            selected?.removeFrom(entryLists: self.savedLists!)
            self.listsTableView.reloadData()
        })
        
        rename.backgroundColor = UIColor.orange
        delete.backgroundColor = UIColor.red
        
        let actions: [UITableViewRowAction] = [rename, delete]
        
        return actions
    }
    
    ///Gets all the saved EntryLists and sorts them alphabetically
    func loadLists() {
        savedLists = getSavedObject(key: .SavedLists) as? [EntryList]
        guard savedLists.hasValue else {
            return
        }
    }
    
    ///Called when user wants to add new EntryList
    func add() {
        showAlert(editingAction: .NewEntryList, index: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue: segue) {
        case .ShowEditList:
            let editListController = segue.destination as! EditListController
            editListController.isNewList = true
            editListController.list = selectedList
        case .ShowViewList:
            let viewListController = segue.destination as! ViewListController
            viewListController.selectedEntryList = savedLists![selectedListIndex]
        }
    }
    
    ///Presents a UIAlertController which lets the user enter the name of an EntryList
    func showAlert(editingAction: editingAction, index: Int?) {
        
        let alertController = UIAlertController(title: "List Name", message: "Enter List Name", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
            textField.placeholder = "List Name"
            if editingAction == .RenameEntryList {
                textField.text = self.savedLists![index!].name
            }
            textField.addTarget(self, action: #selector(self.textChanged(sender:)), for: .editingChanged)
        })
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            guard textField.text != nil else {
                return
            }
            
            //Executed if the user is creating a new list
            if editingAction == .NewEntryList {
                self.selectedList = EntryList(listName: textField.text!, entries: nil)
                self.performSegueWithIdentifier(segueIdentifier: .ShowEditList, sender: nil)
            } else if editingAction == .RenameEntryList { //Executed if the user is renaming an existing list
                //let newList = EntryList(listName: textField.text!, entries: list?.entries)
                //newList.updateEntryList(originalEntryList: list!)
                self.savedLists![index!] ~= textField.text!
                self.savedLists = sortEntryLists(entryLists: self.savedLists!)
                self.saveObject(object: self.savedLists!, key: .SavedLists)
                self.listsTableView.reloadData()
                //self.dismiss(animated: true, completion: nil)
                alertController.dismiss(animated: true, completion: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        actionToEnable = saveAction
        
        if editingAction == .NewEntryList {
            saveAction.isEnabled = false
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    ///Checks whether text has been entered and enables/disables the save button accordingly
    func textChanged(sender: UITextField) {
        actionToEnable?.isEnabled = (sender.text! != "")
    }
    

}

