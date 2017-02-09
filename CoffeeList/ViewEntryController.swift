//
//  ViewEntryController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-24.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit
import CSKit

class ViewEntryController: UIViewController, SegueHandlerType{
    
    enum SegueIdentifier: String {
        case ShowEditSelectedEntry = "showEditSelectedEntry"
    }
    
    //Class Variables
    var selectedEntry: Entry?
    var shouldUpdate = Bool()
    weak var S = Singleton.sharedInstance
    
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblCoffeeType: UILabel!
    
    @IBOutlet var lblFavCoffeeShop: UILabel!
    
    @IBOutlet var txtComments: UITextView!
    
    deinit {
        print("\(self) is being deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewEntryController.cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ViewEntryController.editEntry))
        txtComments.isEditable = false
        shouldUpdate = false
        loadEntry()
    }
    
    ///Used to update entry if it has been edited
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        shouldUpdate = S!.shouldUpdate
        print(shouldUpdate)
        guard shouldUpdate == true else {
            return
        }
        selectedEntry = S!.selectedEntry
        updateEntry()
        shouldUpdate = false
        S!.clearAll()
    }
    
    ///Will load the selected entry when it is first selected
    func loadEntry() {
        lblName.text = selectedEntry?.name
        lblCoffeeType.text = selectedEntry?.coffeeType
        lblFavCoffeeShop.text = selectedEntry?.favCoffeeShop
        txtComments.text = selectedEntry?.comments
    }
    
    ///Updates the selected entry after it has been edited
    func updateEntry() {
        lblName.text = selectedEntry?.name
        lblCoffeeType.text = selectedEntry?.coffeeType
        lblFavCoffeeShop.text = selectedEntry?.favCoffeeShop
        txtComments.text = selectedEntry?.comments
    }
    
    ///Called when the user touches the edit button
    func editEntry() {
        performSegueWithIdentifier(segueIdentifier: .ShowEditSelectedEntry, sender: nil)
    }
    
    ///Passes necessary data to EditEntryController when editing is about to begin
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue: segue) {
        case .ShowEditSelectedEntry:
            let editEntryController: EditEntryController = segue.destination as! EditEntryController
            editEntryController.isNewEntry = false
            editEntryController.entry = selectedEntry
        }
    }
    
}
