//
//  HRMeasurementViewController.swift
//  BloodPressure
//
//  Created by Aleksander Maj on 12/01/2018.
//  Copyright © 2018 Aleksander Maj. All rights reserved.
//

import UIKit
import CoreBluetooth

class HRMeasurementViewController: UIViewController {

    let bluetoothManager: BluetoothManager
    let peripheral: CBPeripheral
    var values = [Int]()
    @IBOutlet weak var hrValueLabel: UILabel!
    @IBOutlet weak var averageHRLabel: UILabel!

    init(bluetoothManager: BluetoothManager, peripheral: CBPeripheral) {
        self.bluetoothManager = bluetoothManager
        self.peripheral = peripheral
        super.init(nibName: nil, bundle: nil)

        bluetoothManager.didReceiveHRValue = { hrMeasurement in
            self.hrValueLabel.text = "\(hrMeasurement.heartRate)"
            self.values.append(hrMeasurement.heartRate)
            let average = self.values.reduce(0, +) / self.values.count
            self.averageHRLabel.text = "Average: \(average)"
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Heart rate"
        bluetoothManager.startMeasurement(for: peripheral)
    }

    @IBAction func doneTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
