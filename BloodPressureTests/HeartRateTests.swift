import XCTest
@testable import BloodPressure

class HeartRateTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testHRMeas1() {
        let dataArray: [UInt8] = [6, 128]
        let data = Data(bytes: dataArray)

        let hrMeas = HeartRateMeasurement(data: data)

        assert(hrMeas.sensorContact == .contactOk)
        assert(hrMeas.heartRate == 128)
        assert(hrMeas.energyExpended == 0)
        assert(hrMeas.rrIntervals.isEmpty)
    }

    func testHRMeas2() {
        let data = Data(bytes: [7, 1, 1])
        let hrMeas = HeartRateMeasurement(data: data)
        assert(hrMeas.sensorContact == .contactOk)
        assert(hrMeas.heartRate == 257)
        assert(hrMeas.energyExpended == 0)
        assert(hrMeas.rrIntervals.isEmpty)
    }

    func testHRMeasEnergyExpended1() {
        var dataArray = [UInt8]()
        dataArray.append(9)
        dataArray.append(contentsOf: UInt16(0xFFFF).to8BitArray())
        dataArray.append(contentsOf: UInt16(0xFFFF).to8BitArray())
        let data = Data(bytes: dataArray)
        let hrMeas = HeartRateMeasurement(data: data)
        assert(hrMeas.sensorContact == .unsupported)
        assert(hrMeas.heartRate == 0xFFFF)
        assert(hrMeas.energyExpended == 0xFFFF)
        assert(hrMeas.rrIntervals.isEmpty)
    }

    func testHRMeasRRIntervals1() {
        var dataArray = [UInt8]()
        dataArray.append(23)
        dataArray.append(contentsOf: UInt16(0xFFFF).to8BitArray())
        dataArray.append(contentsOf: UInt16(0xFFFF).to8BitArray())
        dataArray.append(contentsOf: UInt16(0xFFFF).to8BitArray())
        let data = Data(bytes: dataArray)
        let hrMeas = HeartRateMeasurement(data: data)
        assert(hrMeas.sensorContact == .contactOk)
        assert(hrMeas.heartRate == 0xFFFF)
        assert(hrMeas.energyExpended == 0)
        assert(hrMeas.rrIntervals.count == 2)
        assert(hrMeas.rrIntervals[0] == 0xFFFF)
        assert(hrMeas.rrIntervals[1] == 0xFFFF)
    }
}

extension UInt16 {
    func to8BitArray() -> [UInt8] {
        let lsb = UInt8(self & 0x00FF)
        let msb = UInt8((self & 0xFF00) >> 8)
        return [lsb, msb]
    }
}
