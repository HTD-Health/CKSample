import Foundation
import CoreBluetooth

//protocol UUIDRepresentable {
//    var uuid: CBUUID { get }
//    var rawValue: String { get }
//}
//
//extension UUIDRepresentable {
//    var uuid: CBUUID {
//        return CBUUID(string: self.rawValue)
//    }
//}

class BTManager: NSObject {

    enum Service: String, UUIDRepresentable {
        case heartRate = "180D"
    }

    enum Characteristic: String, UUIDRepresentable {
        case heartRate = "2A37"
        case heardRateDescriptor = "2A38"
    }

    private let centralManager: CBCentralManager
    private var discoveredPeripherals = [CBPeripheral]()

//    var discoveredPeripheralViewModels: [PeripheralViewModel] {
//        let peripherals = discoveredPeripherals.map {
//            return PeripheralViewModel(peripheral: $0)
//        }
//        return peripherals
//    }

    var devicesUpdatedHandler: (([PeripheralViewModel]) -> Void)?
    var didConnectHandler: ((CBPeripheral) -> Void)?

    var didReceiveHRValue: ((BTHeartRateMeasurement) -> Void)?

    private(set) var connectedPeripheral: CBPeripheral?

    override init() {
        centralManager = CBCentralManager(delegate: nil, queue: nil)
        super.init()
        //centralManager.delegate = self
    }

    func connect(to peripheral: CBPeripheral) {
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
}

extension BTManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Powered on!")
            centralManager.scanForPeripherals(withServices: [Service.heartRate.uuid], options: nil)
        default:
            print("Update state: \(central.state.rawValue)")
//            0 - unknown
//            1 - resetting
//            2 - unsupported
//            3 - unauthorized
//            4 - poweredOff
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        addPeripheral(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        didConnectHandler?(peripheral)
        peripheral.discoverServices(nil)
    }
}

extension BTManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.services?
            .filter { $0.uuid == Service.heartRate.uuid }
            .forEach { peripheral.discoverCharacteristics(nil, for: $0)}
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if service.uuid == Service.heartRate.uuid {
            service.characteristics?
                .filter { $0.uuid == Characteristic.heartRate.uuid }
                .forEach { peripheral.setNotifyValue(true, for: $0) }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case Characteristic.heartRate.uuid:
            guard let data = characteristic.value else { break }
            let hrMeasurement = BTHeartRateMeasurement(data: data)
            self.didReceiveHRValue?(hrMeasurement)
        default:
            break
        }
    }
}

extension BTManager {
    fileprivate func addPeripheral(_ peripheral: CBPeripheral) {
        let alreadyDiscovered = discoveredPeripherals.contains { $0.identifier == peripheral.identifier }
        if !alreadyDiscovered {
            discoveredPeripherals.append(peripheral)
            sortPeripherals()
            printPeripherals()

            //devicesUpdatedHandler?(discoveredPeripheralViewModels)
        }
    }

    fileprivate func printPeripherals() {
        print("PERIPHERALS:")
        discoveredPeripherals.forEach {
            print("\(String(describing: $0))")
        }
        print("============")
    }

    fileprivate func sortPeripherals() {
        discoveredPeripherals.sort {
            return $0.name ?? "" > $1.name ?? ""
        }
    }
}
