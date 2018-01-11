import Foundation
import CoreBluetooth

struct PeripheralViewModel {

    enum State: String {
        case connecting = "Connecting..."
        case connected = "Connected"
        case disconnected = "Disconnected"
        case disconnecting = "Disconnecting..."

        init(cbState: CBPeripheralState) {
            switch cbState {
            case .connecting:
                self = .connecting
            case .connected:
                self = .connected
            case .disconnected:
                self = .disconnected
            case .disconnecting:
                self = .disconnecting
            }
        }
    }

    weak var peripheral: CBPeripheral?
    let name: String
    var state: State

    init(peripheral: CBPeripheral) {
        name = peripheral.name ?? "Unnamed device"
        self.peripheral = peripheral
        self.state = State(cbState: peripheral.state)
    }
}

class BTSelectionViewModel {
    let bluetoothManager: BluetoothManager
    weak var coordinator: BTSelectionCoordinator?

    let title = "Available HR sensors"
    let leftBarButtonItemTitle: String? = "Close"

    weak var viewController: BTSelectionViewController? {
        didSet {
            viewController?.numberOfSections = { return 1 }
            viewController?.numberOfRowsInSection = { section in
                return self.peripherals.count
            }
            viewController?.deviceAtIndexPath = { indexPath in
                return self.peripherals[indexPath.row]
            }
            viewController?.leftBarButtonItemHandler = {
                self.coordinator?.dismiss()
            }
            viewController?.didSelectRowAtIndexPath = { indexPath in
                guard let peripheral = self.peripherals[indexPath.row].peripheral else { return }
                self.bluetoothManager.connect(to: peripheral)
            }
        }
    }

    var peripherals = [PeripheralViewModel]()

    init(bluetoothManager: BluetoothManager, coordinator: BTSelectionCoordinator) {
        self.bluetoothManager = bluetoothManager
        self.coordinator = coordinator

        self.bluetoothManager.devicesUpdatedHandler = { peripherals in
            print("devices updated")
            self.peripherals = peripherals
            self.viewController?.tableView.reloadData()
        }
    }
}
