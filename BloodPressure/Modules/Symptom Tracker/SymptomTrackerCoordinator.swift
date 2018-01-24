import CareKit
import ResearchKit

class SymptomTrackerCoordinator: CoordinatorType {
    var navigationController: UINavigationController?

    func start(in navigationConttoller: UINavigationController) {
        print("DO NOTHING")
    }

    typealias Factory = CarePlanStoreFactory & SymptomTrackerFactory

    private let factory: Factory
    private lazy var storeManager = factory.makeStoreManager()

    private lazy var btSelectionCoordinator: BTSelectionCoordinator = {
        return BTSelectionCoordinator()
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
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController = navigationController
        return navigationController
    }

    func didSelectAssessment(_ assessment: Assessment) {

        switch assessment.activityType {
        case .restingHeartRate:
            didSelectHRAssessment(assessment)
        default:
            self.assessmentTaskCoordinator(for: assessment).start(in: self.navigationController!)
        }
    }

    private func didSelectHRAssessment(_ assessment: Assessment) {
        let alertController = UIAlertController(title: "Choose input",
                                                message: "How would you like to enter your heart rate?",
                                                preferredStyle: .actionSheet)

        let manualAction = UIAlertAction(title: "Manual input", style: .default, handler: { _ in
            self.assessmentTaskCoordinator(for: assessment).start(in: self.navigationController!)
        })

        let hrSensorAction = UIAlertAction(title: "Heart rate sensor", style: .default, handler: { _ in
            print("Presenting on: \(self.navigationController)")
            self.btSelectionCoordinator.start(in: self.navigationController!)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(manualAction)
        alertController.addAction(hrSensorAction)
        alertController.addAction(cancelAction)

        navigationController?.present(alertController, animated: true, completion: nil)
    }

    private func assessmentTaskCoordinator(for assessment: Assessment) -> AssessmentTaskCoordinator {
        return AssessmentTaskCoordinator(factory: factory, assessment: assessment)
    }
}
