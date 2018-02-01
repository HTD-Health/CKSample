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
        print(#function)
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
    lazy var peripherals: Observable<[PeripheralViewModel]> = {
        bluetoothManager.peripherals
            .asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                $0.map {
                    print("new peripheral")
                    return PeripheralViewModel(peripheral: $0.peripheral)
                }
            }
    }()

    var scannedPeripherals = Variable<[PeripheralViewModel]>([])
    weak var viewController: BTSelectionViewController? {
        didSet {
            viewController?.leftBarButtonItemHandler = {
                self.coordinator.stop()
            }
        }
    }

    init(bluetoothManager: RxBTManager, coordinator: BTSelectionCoordinator) {
        self.bluetoothManager = bluetoothManager
        self.coordinator = coordinator
    }

    func viewDidLoad() {
        bluetoothManager.startScanning(for: [.heartRate])
    }

    func didSelectViewModel(peripheralViewModel: PeripheralViewModel) {
        guard let peripheral = peripheralViewModel.peripheral else { return }
        peripheralViewModel.state.value = .connecting
        bluetoothManager.connect(to: peripheral)
            .subscribe(onNext: { [weak self] (_) in
                self?.coordinator.stop()
            }, onError: { (error) in
                print(error)
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed in ViewModel")
            })
            .disposed(by: disposeBag)
    }
}
