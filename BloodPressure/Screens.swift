import CareKit

final class Screens {
    private let storeManager: CarePlanStoreManager

    init(storeManager: CarePlanStoreManager) {
        self.storeManager = storeManager
    }

    public func symptomTracker() -> UIViewController {
        let viewController = OCKSymptomTrackerViewController(carePlanStore: storeManager.store)
        viewController.title = "Measurements"
        viewController.glyphType = OCKGlyphType.heart

        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
