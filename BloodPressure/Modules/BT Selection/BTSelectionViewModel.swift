import Foundation
import CoreBluetooth
import RxSwift
import RxBluetoothKit

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

    weak var peripheral: Peripheral?
    let name: String
    let state = Variable<State>(.disconnected)

    init(peripheral: Peripheral) {
        name = peripheral.name ?? "Unnamed device"
        self.peripheral = peripheral
        self.state.value = State(cbState: peripheral.state)
    }
}

class BTSelectionViewModel: ViewModelType {
    typealias Coordinator = BTSelectionCoordinator

    let coordinator: Coordinator
    let bluetoothManager: RxBTManager

    let title = "Available HR sensors"
    let leftBarButtonItemTitle: String? = "Close"

    let disposeBag = DisposeBag()
    var scannedPeripherals = Variable<[PeripheralViewModel]>([])
    weak var viewController: BTSelectionViewController? {
        didSet {
            viewController?.leftBarButtonItemHandler = {
                self.coordinator.stop()
            }
        }
    }

    var peripherals = [PeripheralViewModel]()

    init(bluetoothManager: RxBTManager, coordinator: BTSelectionCoordinator) {
        self.bluetoothManager = bluetoothManager
        self.coordinator = coordinator
    }

    func viewDidLoad() {
        bluetoothManager.startScanning(for: [.heartRate])

        bluetoothManager.peripherals
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { peripherals in
                let viewModels = peripherals.map { PeripheralViewModel(peripheral: $0.peripheral) }
                self.scannedPeripherals.value = viewModels
            })
            .disposed(by: disposeBag)
    }

    func didSelectViewModel(peripheralViewModel: PeripheralViewModel) {
        guard let peripheral = peripheralViewModel.peripheral else { return }

        peripheralViewModel.state.value = .connecting
    }
}
