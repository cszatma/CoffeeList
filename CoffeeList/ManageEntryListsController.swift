//
//  ManageEntryListsController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-15.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

class ManageEntryListsController: UITableViewController, SegueHandler {
    
    typealias SegueIdentifier = EntryHandlerSegueIdentifiers
    
    enum editingAction: String {
        case NewEntryList = "newEntryList"
        case RenameEntryList = "renameEntryList"
    }
    
    var selectedListIndex = Int()
    var newListName: String!
    weak var actionToEnable: UIAlertAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(ManageEntryListsController.back))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ManageEntryListsController.add))
        self.title = "Manage Lists"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.instance.entryLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryTypeCell", for: indexPath)
        let usedList = User.instance.entryLists[indexPath.item]
        cell.textLabel?.text = usedList.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedListIndex = indexPath.row
        performSegue(withIdentifier: .ShowViewEntryList, sender: nil)
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
            User.instance.entryLists.remove(at: indexPath.row)
            User.instance.save(selection: .EntryLists)
            self.tableView.reloadData()
        })
        
        rename.backgroundColor = UIColor.orange
        delete.backgroundColor = UIColor.red
        
        let actions: [UITableViewRowAction] = [rename, delete]
        
        return actions
    }
    
    ///Called when user wants to add new EntryList
    func add() {
        showAlert(editingAction: .NewEntryList, index: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(forSegue: segue) {
        case .ShowEditEntryList:
            let editListController = segue.destination as! EditEntryListController
            editListController.listName = newListName
        case .ShowViewEntryList:
            let viewListController = segue.destination as! ViewEntryListController
            viewListController.selectedEntryList = User.instance.entryLists[selectedListIndex]
        default:
            fatalError("Invalid segue identifier given.")
        }
    }
    
    ///Presents a UIAlertController which lets the user enter the name of an EntryList
    func showAlert(editingAction: editingAction, index: Int?) {
        
        let alertController = UIAlertController(title: "List Name", message: "Enter List Name", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
            textField.placeholder = "List Name"
            if editingAction == .RenameEntryList {
                textField.text = User.instance.entryLists[index!].name
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
                self.newListName = textField.text!
                self.performSegue(withIdentifier: .ShowEditEntryList, sender: nil)
            } else if editingAction == .RenameEntryList { //Executed if the user is renaming an existing list
                User.instance.entryLists[index!].name = textField.text!
                User.instance.save(selection: .EntryLists)
                self.tableView.reloadData()
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
