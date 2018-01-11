//
//  PeripheralTableViewCell.swift
//  BloodPressure
//
//  Created by Aleksander Maj on 11/01/2018.
//  Copyright © 2018 Aleksander Maj. All rights reserved.
//

import UIKit

class PeripheralTableViewCell: UITableViewCell {

    struct ViewModel {
        let name: String
        let isConnecting: Bool

        init(peripheral: PeripheralViewModel) {
            name = peripheral.name
            isConnecting = peripheral.state == .connecting || peripheral.state == .disconnecting
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.name
            viewModel.isConnecting ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
}
