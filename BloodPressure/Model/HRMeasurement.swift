import Foundation

struct HRMeasurement: Codable {
    let deviceName: String
    let values: [Int]
    let date: Date
    let average: Int

    static let dateFormatter = ISO8601DateFormatter()

    var measurementId: String {
        return "hrMeasurement-\(HRMeasurement.dateFormatter.string(from: date))"
    }

    init(deviceName: String = "Unknown device", values: [Int], date: Date) {
        self.deviceName = deviceName
        self.values = values
        self.date = date
        self.average = values.isEmpty ? 0 : values.reduce(0, +) / values.count
    }

    private enum CodingKeys: String, CodingKey {
        case deviceName = "device_name"
        case values
        case date
        case average
    }
}

extension HRMeasurement: FilenameGenerating {
    var fileName: String {
        return measurementId
    }

    static var directory: String {
        return "HRMeasurement"
    }
}
