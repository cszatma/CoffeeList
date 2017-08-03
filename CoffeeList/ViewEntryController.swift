//
//  ViewEntryController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-24.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import CSKit

class ViewEntryController: UIViewController, EntryHandlerViewerDelegate {
    
    // *** Views *** //
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .gray
        return label
    }()
    
    let coffeeTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .gray
        return label
    }()
    
    let favCoffeeShopLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .gray
        return label
    }()
    
    let commentsTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.isEditable = false
        textView.setBorder(width: 2, color: .gray)
        return textView
    }()
    
    func generateLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }
    // *** End Views *** //
    
    var selectedEntry: Entry!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ViewEntryController.handleEditEntry))
        view.backgroundColor = .white
        setupView()
        loadEntry()
    }
    
    func setupView() {
        let topOffset = view.height / 8
        // nameLabel
        view.addSubview(nameLabel)
        nameLabel.centerX(to: view)
        nameLabel.top(to: view, offset: topOffset)
        nameLabel.width(to: view, multiplier: 1/2)
        nameLabel.height(to: view, multiplier: 1/8)
        
        // coffeeTypeLabel
        view.addSubview(coffeeTypeLabel)
        coffeeTypeLabel.centerX(to: view)
        coffeeTypeLabel.topToBottom(of: nameLabel, offset: topOffset)
        coffeeTypeLabel.width(to: nameLabel)
        coffeeTypeLabel.height(to: nameLabel)
        
        // favCoffeeShopLabel
        view.addSubview(favCoffeeShopLabel)
        favCoffeeShopLabel.centerX(to: view)
        favCoffeeShopLabel.topToBottom(of: coffeeTypeLabel, offset: topOffset)
        favCoffeeShopLabel.width(to: nameLabel)
        favCoffeeShopLabel.height(to: nameLabel)
        
        // commentsTextView
        view.addSubview(commentsTextView)
        commentsTextView.centerX(to: view)
        commentsTextView.topToBottom(of: favCoffeeShopLabel, offset: topOffset)
        commentsTextView.width(to: nameLabel)
        commentsTextView.height(to: nameLabel, multiplier: 2)
    }
    
    ///Will load the selected entry
    func loadEntry() {
        nameLabel.text = selectedEntry?.name
        coffeeTypeLabel.text = selectedEntry?.coffeeType
        favCoffeeShopLabel.text = selectedEntry?.favCoffeeShop
        commentsTextView.text = selectedEntry?.comments
    }
    
    ///Called when the user touches the edit button
    func handleEditEntry() {
        let viewController = EditEntryController()
        viewController.entry = selectedEntry
        viewController.entryHandlerDelegate = self
        navigationController?.present(viewController: viewController, animationType: .fade)
    }
    
    ///Notifies the ViewController to update the displayed values for the entry.
    func updateEntryType() {
        loadEntry()
    }
    
}
