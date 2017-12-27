import CareKit
import ResearchKit

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

    public func task(_ task: ORKTask) -> UIViewController {
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        return taskViewController
    }
}
