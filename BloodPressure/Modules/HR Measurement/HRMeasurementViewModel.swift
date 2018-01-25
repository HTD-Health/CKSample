import Foundation

class HRMeasurementViewModel: ViewModelType {

    typealias Coordinator = HRMeasurementCoordinator

    private let bluetoothManager: BluetoothManager

    let coordinator: Coordinator
    weak var viewController: HRMeasurementViewController?

    var updateDeviceStatusHandler: ((_ status: String, _ deviceName: String) -> Void)?
    var updateMeasurementStatus: ((HRMeasurementStatus) -> Void)?

    private var isRecording: Bool = false
    private var values = [Int]()

    init(bluetoothManager: BluetoothManager, coordinator: Coordinator) {
        self.bluetoothManager = bluetoothManager
        self.coordinator = coordinator
        bluetoothManager.didReceiveHRValue = { [unowned self] hrMeasurement in
            if self.isRecording {
                self.values.append(hrMeasurement.heartRate)
                let average = self.values.reduce(0, +) / self.values.count
                self.updateMeasurementStatus?(HRMeasurementStatus.recording("\(hrMeasurement.heartRate)", "Average: \(average)"))
            } else {
                self.updateMeasurementStatus?(HRMeasurementStatus.connected("\(hrMeasurement.heartRate)"))
            }
        }
    }

    func doneTapped() {
        isRecording = !isRecording
    }

    func deviceButtonTapped() {
        coordinator.presentBTSelection()
    }

    func viewWillAppear() {
        updateDeviceStatus()
    }

    private func updateDeviceStatus() {
        var status: String = "Not connected"
        var name: String = "Connect"

        if let peripheral = bluetoothManager.connectedPeripheral {
            status = "Connected: "
            name = "\(peripheral.name ?? "Unknown")"
            updateMeasurementStatus?(HRMeasurementStatus.connected("--"))
        }
        updateDeviceStatusHandler?(status, name)
    }
}

enum HRMeasurementStatus {
    case disconnected
    case connected(String)
    case recording(String, String)
}
