//
//  ViewEntryController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-24.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

class ViewEntryController: UIViewController, SegueHandlerType, EntryHandlerViewerDelegate {
    
    enum SegueIdentifier: String {
        case ShowEditSelectedEntry = "showEditSelectedEntry"
    }
    
    var selectedEntry: Entry!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblCoffeeType: UILabel!
    @IBOutlet var lblFavCoffeeShop: UILabel!
    @IBOutlet var txtComments: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ViewEntryController.editEntry))
        loadEntry()
    }
    
    ///Will load the selected entry
    func loadEntry() {
        lblName.text = selectedEntry?.name
        lblCoffeeType.text = selectedEntry?.coffeeType
        lblFavCoffeeShop.text = selectedEntry?.favCoffeeShop
        txtComments.text = selectedEntry?.comments
    }
    
    ///Called when the user touches the edit button
    func editEntry() {
        performSegue(withIdentifier: .ShowEditSelectedEntry, sender: nil)
    }
    
    ///Passes necessary data to EditEntryController when editing is about to begin
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segueIdentifier(forSegue: segue) == .ShowEditSelectedEntry else {
            fatalError("Unknown Identifier used to initiate segue.")
        }
        let navController = segue.destination as! UINavigationController
        let editEntryController = navController.viewControllers[0] as! EditEntryController
        editEntryController.entry = selectedEntry
        editEntryController.entryHandlerDelegate = self
    }
    
    func updateEntryType<T: EntryHandler>(with entryHandler: T) {
        selectedEntry = entryHandler as! Entry
        loadEntry()
    }
    
}
