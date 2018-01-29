//
//  BTSelectionViewController.swift
//  BloodPressure
//
//  Created by Aleksander Maj on 11/01/2018.
//  Copyright © 2018 Aleksander Maj. All rights reserved.
//

import UIKit

class BTSelectionViewController: UITableViewController, ViewControllerType {
    typealias ViewModel = BTSelectionViewModel
    let viewModel: ViewModel

    var numberOfSections: (() -> Int)?
    var numberOfRowsInSection: ((Int) -> Int)?
    var deviceAtIndexPath: ((IndexPath) -> PeripheralViewModel?)?
    var leftBarButtonItemHandler: (() -> Void)?
    var didSelectRowAtIndexPath: ((IndexPath) -> Void)?

    init(viewModel: BTSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        if let leftBarButtonTitle = viewModel.leftBarButtonItemTitle {
            let leftBarButtonItem = UIBarButtonItem(title: leftBarButtonTitle, style: .plain, target: self,
                                                    action: #selector(leftBarButtonItemTapped))
            self.navigationItem.leftBarButtonItem = leftBarButtonItem
        }

        if #available(iOS 11, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }

        tableView.register(UINib.init(nibName: "PeripheralTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        viewModel.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections?() ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection?(section) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PeripheralTableViewCell,
            let device = deviceAtIndexPath?(indexPath) else { fatalError() }

        cell.viewModel = PeripheralTableViewCell.ViewModel(peripheral: device)

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAtIndexPath?(indexPath)
    }
}

extension BTSelectionViewController {
    @objc func leftBarButtonItemTapped() {
        leftBarButtonItemHandler?()
    }
}
