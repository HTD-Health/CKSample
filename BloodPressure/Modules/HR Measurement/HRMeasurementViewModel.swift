import Foundation
import RxSwift
import RxCocoa

class HRMeasurementViewModel: ViewModelType {

    typealias Coordinator = HRMeasurementCoordinator

    private let bluetoothManager: BluetoothManager

    let coordinator: Coordinator
    weak var viewController: HRMeasurementViewController?

    var updateDeviceStatusHandler: ((_ status: String, _ deviceName: String) -> Void)?
    var updateMeasurementStatusHandler: ((_ isRecording: Bool) -> Void)?

    private var isRecording: Bool = false
    private var values = [Int]()

    let hrValue: Variable<BTHeartRateMeasurement?> = Variable(nil)

    let heartRateText = Variable<String>("--")
    let averageHeartRateText = Variable<String>("--")

    let measurementStatus = Variable<HRMeasurementStatus>(.disconnected)
    init(bluetoothManager: BluetoothManager, coordinator: Coordinator) {
        self.bluetoothManager = bluetoothManager
        self.coordinator = coordinator

        self.setUpHRValueObserving()
    }

    func actionButtonTapped() {
        isRecording = !isRecording

        updateMeasurementStatusHandler?(isRecording)
        if !isRecording {
            // Store recording in a file
            let hrMeasurement = HRMeasurement(deviceName: bluetoothManager.connectedPeripheral?.name ?? "Unknown name",
                                              values: values,
                                              date: Date())
            FileStorage.store(hrMeasurement)
            coordinator.stop()
       }
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
            measurementStatus.value = .connected("__")
        }
        updateDeviceStatusHandler?(status, name)
    }

    private func setUpHRValueObserving() {
        bluetoothManager.didReceiveHRValue = { [unowned self] hrMeasurement in

            self.hrValue.value = hrMeasurement
            self.heartRateText.value = "\(hrMeasurement.heartRate)"

            if self.isRecording {
                self.values.append(hrMeasurement.heartRate)
                let average = self.values.reduce(0, +) / self.values.count
                self.averageHeartRateText.value = "Average: \(average)"
            }
        }
    }
}

enum HRMeasurementStatus {
    case disconnected
    case connected(String)
    case recording(String, String)
}
