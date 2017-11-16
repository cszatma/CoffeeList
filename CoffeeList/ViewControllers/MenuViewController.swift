//
//  ViewController.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-19.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import TinyConstraints

class MenuViewController: UIViewController {

    // *** Views *** //
    let entriesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Entries", for: .normal)
        button.backgroundColor = .lightGray
        button.cornerRadius = 40
        button.addTarget(self, action: #selector(handleButtonTouch(_:)), for: .touchUpInside)
        return button
    }()

    let listsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Lists", for: .normal)
        button.backgroundColor = .lightGray
        button.cornerRadius = 40
        button.addTarget(self, action: #selector(handleButtonTouch(_:)), for: .touchUpInside)
        return button
    }()
    // *** End Views *** //

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }

    /// Handles the touch events for each button.
    @objc func handleButtonTouch(_ sender: UIButton) {
        let viewController = sender == entriesButton ? ManageEntriesController() : ManageCoffeeListsController()
        present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
    }
}

extension MenuViewController {
    /// Sets up and necessary constraints and adds created views to main view.
    func setupView() {

        // entriesButton
        view.addSubview(entriesButton)
        entriesButton.centerX(to: view)
        entriesButton.top(to: view, offset: view.height / 4)
        entriesButton.width(to: view, multiplier: 1/2)
        entriesButton.height(to: view, multiplier: 1/8)

        // listsButton
        view.addSubview(listsButton)
        listsButton.centerX(to: view)
        listsButton.topToBottom(of: entriesButton, offset: view.height / 6)
        listsButton.width(to: entriesButton)
        listsButton.height(to: entriesButton)
    }
}



