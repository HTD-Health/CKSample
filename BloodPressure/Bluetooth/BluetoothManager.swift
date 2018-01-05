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

struct HeartRateMeasurement {
    enum SensorContact: UInt8 {
        case unsupported
        case turnedOff
        case tooWeak
        case contactOk
    }

    private let hrFormatBit: UInt8
    let sensorContact: SensorContact
    private let energyExpendedBit: UInt8
    private let rrIntervalBit: UInt8

    let heartRate: Int
    let energyExpended: Int
    let rrIntervals: [Int]

    init(data: Data) {
        var offset = 0
        let flagsField = data[offset]
        hrFormatBit = flagsField & 0x01
        sensorContact = SensorContact(rawValue: (flagsField & 0x06) >> 1) ?? SensorContact.unsupported
        energyExpendedBit = (flagsField & 0x08) >> 3
        rrIntervalBit = (flagsField & 0x10) >> 4

        offset += 1
        heartRate = Int(data[offset]) + (hrFormatBit == 1 ? Int(data[offset + 1]) << 8 : 0)

        offset += 1 + Int(hrFormatBit)
        var energy = 0
        if energyExpendedBit == 1 {
            energy = Int(data[offset]) + Int(data[offset + 1]) << 8
            offset += 2
        }
        energyExpended = energy

        var rrIntervals = [Int]()
        if rrIntervalBit == 1 {
            while offset < data.count {
                rrIntervals.append(Int(data[offset]) + Int(data[offset + 1]) << 8)
                offset += 2
            }
        }
        self.rrIntervals = rrIntervals
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

    override init() {
        centralManager = CBCentralManager(delegate: nil, queue: nil)
        super.init()
        centralManager.delegate = self
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
        peripheral.discoverServices(nil)
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
                case Characteristic.heardRateDescriptor.uuid:
                    peripheral.readValue(for: $0)
                default:
                    break
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
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

            if let name = peripheral.name, name.starts(with: "Polar") {
                peripheral.delegate = self
                centralManager.connect(peripheral, options: nil)
            }
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
