import CareKit
import ResearchKit

class SymptomTrackerCoordinator: ModalCoordinatorType {

    typealias ViewController = SymptomTrackerViewController
    typealias Factory = CarePlanStoreFactory & SymptomTrackerFactory

    let navigationController: UINavigationController

    private let factory: Factory
    private lazy var storeManager = factory.makeStoreManager()

    init(factory: Factory) {
        self.factory = factory
        self.navigationController = UINavigationController()
    }

    func symptomTracker() -> UIViewController {
        let viewController = makeViewController()
        navigationController.viewControllers = [viewController]
        return navigationController
    }

    func makeViewController() -> UIViewController {
        let viewModel = SymptomTrackerViewModel(activityManager: storeManager.sampleData, coordinator: self)
        let viewController = SymptomTrackerViewController(carePlanStore: storeManager.store)
        viewController.viewModel = viewModel
        viewController.delegate = viewModel

        viewController.title = "Symptom Tracker"
        viewController.glyphType = OCKGlyphType.heart
        return viewController
    }

    func start() {
        print("do nothing")
    }

    func didSelectAssessment(_ assessment: Assessment) {
        switch assessment.activityType {
        case .restingHeartRate:
            didSelectHRAssessment(assessment)
        default:
            assessmentTaskCoordinator(for: assessment).start()
        }
    }

    private func didSelectHRAssessment(_ assessment: Assessment) {
        let alertController = UIAlertController(title: "Choose input",
                                                message: "How would you like to enter your heart rate?",
                                                preferredStyle: .actionSheet)

        let manualAction = UIAlertAction(title: "Manual input", style: .default, handler: { _ in
            self.assessmentTaskCoordinator(for: assessment).start()
        })

        let hrSensorAction = UIAlertAction(title: "Heart rate sensor", style: .default, handler: { _ in
            self.makeHRMeasurementCoordinator(for: assessment).start()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(manualAction)
        alertController.addAction(hrSensorAction)
        alertController.addAction(cancelAction)

        navigationController.present(alertController, animated: true, completion: nil)
    }

    private func assessmentTaskCoordinator(for assessment: Assessment) -> AssessmentTaskCoordinator {
        return AssessmentTaskCoordinator(factory: factory, assessment: assessment, navigationController: navigationController)
    }

    private func makeHRMeasurementCoordinator(for assessment: Assessment) -> HRMeasurementCoordinator {
        return HRMeasurementCoordinator(navigationController: navigationController, assessment: assessment)
    }
}
