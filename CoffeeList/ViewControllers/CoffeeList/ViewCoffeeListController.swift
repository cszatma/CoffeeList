//
//  ViewCoffeeListController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-11-16.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit

class ViewCoffeeListController: UIViewController {

    // *** Views *** //
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .gray
        label.cornerRadius = 10
        label.font = label.font.withSize(20)
        return label
    }()

    let coffeeTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.isEditable = false
        textView.setBorder(width: 2, color: .gray)
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }()

    let notesTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.isEditable = false
        textView.setBorder(width: 2, color: .gray)
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }()
    // *** End Views *** //

    var coffeeList: CoffeeList!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
        self.title = coffeeList.name
        view.backgroundColor = .white
        setupView()
        loadCoffeeList()
    }

    func loadCoffeeList() {
        nameLabel.text = coffeeList.name
        notesTextView.text = coffeeList.notes
        coffeeTextView.text = coffeeList.generateCoffeeDictionary().flatMap({
            "\($0.value) \($0.key)"
        }).joined(separator: "\n")
    }

    @objc func handleEdit() {
        let viewController = EditCoffeeListController()
        viewController.coffeeList = coffeeList
        viewController.delegate = self
        navigationController?.present(viewController: viewController, animationType: .fade)
    }
}

extension ViewCoffeeListController: CoffeeListDelegate {
    func update(newValue: CoffeeList) {
        coffeeList = newValue
        loadCoffeeList()
        (navigationController?.viewControllers[0] as! ManageCoffeeListsController).update(newValue: newValue)
    }
}

extension ViewCoffeeListController {
    func setupView() {
        let topOffset = view.height / 16
        // nameLabel
        view.addSubview(nameLabel)
        nameLabel.centerX(to: view)
        nameLabel.top(to: view, offset: navigationController!.navigationBar.height + 30)
        nameLabel.width(to: view, offset: -20)
        nameLabel.height(to: view, multiplier: 1/10)

        // coffeeTextView
        view.addSubview(coffeeTextView)
        coffeeTextView.centerX(to: view)
        coffeeTextView.topToBottom(of: nameLabel, offset: topOffset)
        coffeeTextView.width(to: nameLabel)
        coffeeTextView.height(to: nameLabel)

        // notesTextView
        view.addSubview(notesTextView)
        notesTextView.centerX(to: view)
        notesTextView.topToBottom(of: coffeeTextView, offset: topOffset)
        notesTextView.width(to: nameLabel)
        //        notesTextView.height(to: nameLabel, multiplier: 2)
        notesTextView.bottom(to: view, offset: -30)
    }
}

