import Foundation

class HRMeasurementViewModel {
    private let bluetoothManager: BluetoothManager

    weak var viewController: HRMeasurementViewController?
    var coordinator: HRMeasurementCoordinator

    private var values = [Int]()

    init(bluetoothManager: BluetoothManager, coordinator: HRMeasurementCoordinator) {
        self.bluetoothManager = bluetoothManager
        self.coordinator = coordinator
        bluetoothManager.didReceiveHRValue = { hrMeasurement in
            self.values.append(hrMeasurement.heartRate)
            let average = self.values.reduce(0, +) / self.values.count
            self.viewController?.hrValueDidUpdate(hrValue: hrMeasurement.heartRate)
            self.viewController?.hrAverageValueDidUpdate(averageValue: average)
        }
    }
}

extension HRMeasurementViewModel: ViewModelType {
    typealias Coordinator = HRMeasurementCoordinator

    func viewDidLoad() {
        bluetoothManager.startMeasurement()
    }

    func doneTapped() {
        coordinator.measurementDidFinish()
    }
}
