import Foundation

class HRMeasurementViewModel: ViewModelType {

    typealias Coordinator = HRMeasurementCoordinator

    private let bluetoothManager: BluetoothManager

    let coordinator: Coordinator
    weak var viewController: HRMeasurementViewController?

    private var values = [Int]()

    init(bluetoothManager: BluetoothManager, coordinator: Coordinator) {
        self.bluetoothManager = bluetoothManager
        self.coordinator = coordinator
        bluetoothManager.didReceiveHRValue = { hrMeasurement in
            self.values.append(hrMeasurement.heartRate)
            let average = self.values.reduce(0, +) / self.values.count
            self.viewController?.hrValueDidUpdate(hrValue: hrMeasurement.heartRate)
            self.viewController?.hrAverageValueDidUpdate(averageValue: average)
        }
    }

    func doneTapped() {
        coordinator.measurementDidFinish()
    }

    func viewDidLoad() {
        bluetoothManager.startMeasurement()
    }
}
