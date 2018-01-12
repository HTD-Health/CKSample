import Foundation
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

class BluetoothManager: NSObject {

    enum Service: String, UUIDRepresentable {
        case heartRate = "180D"
    }

    enum Characteristic: String, UUIDRepresentable {
        case heartRate = "2A37"
        case heardRateDescriptor = "2A38"
    }

    private let centralManager: CBCentralManager
    private var discoveredPeripherals = [CBPeripheral]()

    var devicesUpdatedHandler: (([PeripheralViewModel]) -> Void)?
    var didConnectHandler: ((CBPeripheral) -> Void)?

    var didReceiveHRValue: ((HeartRateMeasurement) -> Void)?

    override init() {
        centralManager = CBCentralManager(delegate: nil, queue: nil)
        super.init()
        centralManager.delegate = self
    }

    func connect(to peripheral: CBPeripheral) {
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
    }

    func startMeasurement(for peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
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
        print("ADVERTISEMENT DATA:")
        print(advertisementData)
        addPeripheral(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print(#function)
        didConnectHandler?(peripheral)
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print(#function)
        peripheral.services?.forEach {
            print(String(describing: $0))
            if $0.uuid == Service.heartRate.uuid {
                peripheral.discoverCharacteristics(nil, for: $0)
                peripheral.discoverIncludedServices(nil, for: $0)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print(#function)
        if service.uuid == Service.heartRate.uuid {
            service.characteristics?.forEach {
                switch $0.uuid {
                case Characteristic.heartRate.uuid:
                    peripheral.setNotifyValue(true, for: $0)
//                case Characteristic.heardRateDescriptor.uuid:
//                    peripheral.readValue(for: $0)
                default:
                    break
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverInclussdedServicesFor service: CBService, error: Error?) {
        print(#function)
        print(String(describing: service.includedServices))
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //print(#function)
        switch characteristic.uuid {
        case Characteristic.heartRate.uuid:
            //print("MEAS")
            guard let data = characteristic.value else { break }
            let hrMeasurement = HeartRateMeasurement(data: data)
            self.didReceiveHRValue?(hrMeasurement)
        case Characteristic.heardRateDescriptor.uuid:
            print("DESC")
        default:
            break
        }

    }
}

extension BluetoothManager {
    fileprivate func addPeripheral(_ peripheral: CBPeripheral) {
        let alreadyDiscovered = discoveredPeripherals.contains { $0.identifier == peripheral.identifier }
        if !alreadyDiscovered {
            discoveredPeripherals.append(peripheral)
            sortPeripherals()
            printPeripherals()

            let devices = discoveredPeripherals.map {
                return PeripheralViewModel(peripheral: $0)
            }

            devicesUpdatedHandler?(devices)

//            if let name = peripheral.name, name.starts(with: "Polar") {
//                peripheral.delegate = self
//                centralManager.connect(peripheral, options: nil)
//            }
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
