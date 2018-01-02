import CareKit

class CarePlanStoreManager: NSObject {
    let store: OCKCarePlanStore
    let sampleData: SampleData

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
        self.sampleData = SampleData(carePlanStore: store)
        super.init()
        self.store.delegate = self
    }
}

extension CarePlanStoreManager: OCKCarePlanStoreDelegate {

}
