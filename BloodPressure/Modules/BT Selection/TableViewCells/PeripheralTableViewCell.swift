//
//  PeripheralTableViewCell.swift
//  BloodPressure
//
//  Created by Aleksander Maj on 11/01/2018.
//  Copyright © 2018 Aleksander Maj. All rights reserved.
//

import UIKit
import RxSwift

class PeripheralTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!

    var disposeBag = DisposeBag()

    func configure(with viewModel: PeripheralViewModel) {
        titleLabel.text = viewModel.name
        viewModel.state.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                print("Updating state")
                switch $0 {
                case .connecting, .disconnecting:
                    self.activityIndicator.startAnimating()
                    self.stackView.removeArrangedSubview(self.statusLabel)
                    self.statusLabel.isHidden = true
                    self.statusLabel.text = $0.rawValue
                case .connected:
                    self.activityIndicator.stopAnimating()
                    self.stackView.addArrangedSubview(self.statusLabel)
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = $0.rawValue
                case .disconnected:
                    self.stackView.removeArrangedSubview(self.statusLabel)
                    self.statusLabel.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.statusLabel.text = $0.rawValue
                }
            })
            .disposed(by: disposeBag)
    }

    override func prepareForReuse() {
        print(#function)
        disposeBag = DisposeBag()
    }
}
