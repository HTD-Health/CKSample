import CareKit
import ResearchKit

final class Screens {
    private let storeManager: CarePlanStoreManager

    init(storeManager: CarePlanStoreManager) {
        self.storeManager = storeManager
    }

    public func task(_ task: ORKTask) -> UIViewController {
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        return taskViewController
    }
}
