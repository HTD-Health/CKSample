import CareKit

class CarePlanStoreManager: NSObject {
    let store: OCKCarePlanStore

    convenience override init() {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Unable to get the document directory!")
        }

        let storeURL = documentDirectory.appendingPathComponent("BloodPressureStore")

        if !fileManager.fileExists(atPath: storeURL.path) {
            do {
                try fileManager.createDirectory(at: storeURL,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                fatalError("\(error.localizedDescription)")
            }
        }
        self.init(storeURL: storeURL)
    }

    init(storeURL: URL) {
        self.store = OCKCarePlanStore(persistenceDirectoryURL: storeURL)
        super.init()
        self.store.delegate = self
        self.addSampleData()
    }

    private func addSampleData() {
        let restingHeartRate = RestingHeartRate()
        self.store.add(restingHeartRate.carePlanActivity) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }

        let bloodPressure = BloodPressure()
        self.store.add(bloodPressure.carePlanActivity) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }

    }
}

extension CarePlanStoreManager: OCKCarePlanStoreDelegate {

}
