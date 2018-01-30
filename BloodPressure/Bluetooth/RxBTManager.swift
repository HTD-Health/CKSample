import RxBluetoothKit
import RxSwift
import CoreBluetooth

protocol UUIDRepresentable {
    var uuid: CBUUID { get }
    var rawValue: String { get }
}

extension UUIDRepresentable {
    var uuid: CBUUID {
        return CBUUID(string: self.rawValue)
    }
}

class RxBTManager {
    let bluetoothManager = BluetoothManager(queue: .main)
    private var scanningDisposable: Disposable?
    private var peripherals = [ScannedPeripheral]()

    enum Service: String, UUIDRepresentable {
        case heartRate = "180D"
    }

    func startScanning(for services: [Service]) {
        scanningDisposable = bluetoothManager.rx_state
            .timeout(4.0, scheduler: MainScheduler.instance)
            .filter { $0 == .poweredOn}
            .take(1)
            .flatMap { _ in
                self.bluetoothManager.scanForPeripherals(withServices: services.map { $0.uuid })
            }
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { self.addNewScannedPeripheral($0) },
                       onError: { error in print("timeout? " + error.localizedDescription) })

    }

    func stopScanning() {
        scanningDisposable?.dispose()
    }

    private func addNewScannedPeripheral(_ peripheral: ScannedPeripheral) {
        if let index = (peripherals.index { $0.peripheral == peripheral.peripheral }) {
            peripherals[index] = peripheral
        } else {
            peripherals.append(peripheral)
            print(String(describing: peripheral.peripheral.name))
        }
    }
}
