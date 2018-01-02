import CareKit

protocol ActivityManager {
    func activityWithType(_ type: ActivityType) -> Activity?
}

class SampleData {
    fileprivate let activities: [Activity] = [
        BloodPressure(),
        RestingHeartRate()
    ]

    init(carePlanStore: OCKCarePlanStore) {
        activities.forEach {
            carePlanStore.add($0.carePlanActivity, completion: { (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        }
    }
}

extension SampleData: ActivityManager {
    func activityWithType(_ type: ActivityType) -> Activity? {
        return activities.filter { $0.activityType == type }.first
    }
}
