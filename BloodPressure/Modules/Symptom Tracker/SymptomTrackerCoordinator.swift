import CareKit
import ResearchKit

class SymptomTrackerCoordinator {
    typealias Factory = CarePlanStoreFactory & SymptomTrackerFactory

    private let factory: Factory
    private lazy var storeManager = factory.makeStoreManager()
    private var navigationController = UINavigationController()

    private lazy var assessmentTaskCoordinator: AssessmentTaskCoordinator = {
        return AssessmentTaskCoordinator(factory: factory)
    }()

    init(factory: Factory) {
        self.factory = factory
    }

    func symptomTracker() -> UIViewController {
        let viewModel = SymptomTrackerViewModel(activityManager: storeManager.sampleData, coordinator: self)
        let viewController = SymptomTrackerViewController(carePlanStore: storeManager.store)
        viewController.viewModel = viewModel
        viewController.delegate = viewModel

        viewController.title = "Symptom Tracker"
        viewController.glyphType = OCKGlyphType.heart
        navigationController.viewControllers = [viewController]
        return navigationController
    }

    func didSelectAssessment(_ assessment: Assessment) {
        assessmentTaskCoordinator.presentAssessmentTask(for: assessment, in: navigationController)
    }
}
