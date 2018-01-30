//
//  BTSelectionViewController.swift
//  BloodPressure
//
//  Created by Aleksander Maj on 11/01/2018.
//  Copyright © 2018 Aleksander Maj. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BTSelectionViewController: UITableViewController, ViewControllerType {
    typealias ViewModel = BTSelectionViewModel
    typealias PeripheralCell = PeripheralTableViewCell

    let viewModel: ViewModel
    let disposeBag = DisposeBag()

    var leftBarButtonItemHandler: (() -> Void)?

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.tableFooterView = UIView()

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

        populatePeripheralsListTableView()
        viewModel.viewDidLoad()

    }

    private func populatePeripheralsListTableView() {
        viewModel.scannedPeripherals.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: PeripheralCell.self)) { (_, cellViewModel, cell) in
                cell.viewModel = cellViewModel
            }
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(PeripheralViewModel.self)
            .subscribe(onNext: { value in
                self.viewModel.didSelectViewModel(peripheralViewModel: value)
            })
            .disposed(by: disposeBag)
    }
}

extension BTSelectionViewController {
    @objc func leftBarButtonItemTapped() {
        leftBarButtonItemHandler?()
    }
}
