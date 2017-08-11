//
//  ManageCoffeeListsController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-15.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

class ManageCoffeeListsController: UITableViewController, CLTypeViewerDelegate {
    
    enum EditingAction: String {
        case NewCoffeeList = "newCoffeeList"
        case RenameCoffeeList = "renameCoffeeList"
    }
    
    var newListName: String!
    var inputAlertController: UIAlertController?
    weak var actionToEnable: UIAlertAction?
    fileprivate let cellId = "coffeeListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(ManageCoffeeListsController.back))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ManageCoffeeListsController.add))
        self.title = "Manage Lists"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.instance.coffeeLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = User.instance.coffeeLists[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentController(index: indexPath.row)
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
            self.showAlert(editingAction: .RenameCoffeeList, index: indexPath.row)
        })
        
        //delete action
        let delete = UITableViewRowAction(style: .normal, title: "Delete", handler: {_,_ in
            User.instance.removeElement(from: .CoffeeLists, at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        
        rename.backgroundColor = UIColor.orange
        delete.backgroundColor = UIColor.red
        
        let actions: [UITableViewRowAction] = [rename, delete]
        
        return actions
    }
    
    ///Called when user wants to add new CoffeeList
    func add() {
        showAlert(editingAction: .NewCoffeeList, index: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segueIdentifier(forSegue: segue) {
//        case .ShowEditCoffeeList:
//            let editListController = segue.destination as! EditCoffeeListController
//            editListController.listName = newListName
//        case .ShowViewCoffeeList:
//            let viewListController = segue.destination as! ViewCoffeeListController
//            viewListController.selectedCoffeeList = User.instance.coffeeLists[selectedListIndex]
//        default:
//            fatalError("Invalid segue identifier given.")
//        }
//    }
    
    ///Presents a UIAlertController which lets the user enter the name of an CoffeeList
    func showAlert(editingAction: EditingAction, index: Int?) {
        
        let alertController = UIAlertController(title: "List Name", message: "Enter List Name", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
            textField.placeholder = "List Name"
            textField.addTarget(self, action: #selector(self.textChanged(sender:)), for: .editingChanged)
            if editingAction == .RenameCoffeeList {
                textField.text = User.instance.coffeeLists[index!].name
            }
        })
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            
            //Executed if the user is creating a new list
            if editingAction == .NewCoffeeList {
                self.newListName = textField.text!
                self.presentController(index: nil)
            } else if editingAction == .RenameCoffeeList { //Executed if the user is renaming an existing list
                User.instance.coffeeLists[index!].name = textField.text!
                User.instance.save(selection: .CoffeeLists)
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
        
        saveAction.isEnabled = false
        inputAlertController = alertController
        self.present(alertController, animated: true, completion: nil)
    }
    
//    func createAlertController() -> UIAlertController {
//        let alertController = UIAlertController(title: "List Name", message: "Enter List Name", preferredStyle: .alert)
//        alertController.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
//            textField.placeholder = "List Name"
//            textField.addTarget(self, action: #selector(self.textChanged(sender:)), for: .editingChanged)
//        })
//        
//        
//        
//        return alertController
//    }
//    
//    func createSaveAction(alertController: UIAlertController, editingAction: EditingAction) -> UIAlertAction {
//        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
//            alert -> Void in
//            let textField = alertController.textFields![0] as UITextField
//            
//            //Executed if the user is creating a new list
//            if editingAction == .NewCoffeeList {
//                self.newListName = textField.text!
//                ///Push to edit controller
//            } else if editingAction == .RenameCoffeeList { //Executed if the user is renaming an existing list
//                User.instance.coffeeLists[index!].name = textField.text!
//                User.instance.save(selection: .CoffeeLists)
//                self.tableView.reloadData()
//                alertController.dismiss(animated: true, completion: nil)
//            }
//        })
//    }
    
    ///Checks whether text has been entered and enables/disables the save button accordingly
    func textChanged(sender: UITextField) {
        actionToEnable?.isEnabled = !sender.text!.isEmpty //FIX
    }
    
    func presentController(index: Int?) {
        let viewController: UIViewController
        if let coffeeListIndex = index {
            viewController = ViewCoffeeListController()
            (viewController as! ViewCoffeeListController).selectedCoffeeList = User.instance.coffeeLists[coffeeListIndex]
        } else {
            viewController = EditCoffeeListController()
            (viewController as! EditCoffeeListController).delegate = self
        }
        navigationController?.pushViewController(viewController, animated: true)

    }
    
    func updateEntryType() {
        tableView.reloadData()
    }
    
}
