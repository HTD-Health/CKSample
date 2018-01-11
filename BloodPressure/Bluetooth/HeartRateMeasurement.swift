import Foundation

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
        sensorContact = SensorContact(rawValue: (flagsField & 0x06) >> 1)!
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
