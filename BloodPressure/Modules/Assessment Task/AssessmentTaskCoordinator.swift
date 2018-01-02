import ResearchKit
import CareKit

class AssessmentTaskCoordinator {
    typealias Factory = CarePlanStoreFactory

    private weak var viewController: UIViewController?
    private let factory: Factory
    private lazy var storeManager = factory.makeStoreManager()

    init(factory: Factory) {
        self.factory = factory
    }

    func presentAssessmentTask(for assessment: Assessment, in navigationController: UINavigationController) {
        let viewModel = AssessmentTaskViewModel(coordinator: self, assessment: assessment, storeManager: storeManager)

        let taskViewController = AssessmentTaskViewController(task: assessment.task, taskRun: nil)
        taskViewController.viewModel = viewModel
        taskViewController.delegate = viewModel

        viewController = taskViewController
        navigationController.present(taskViewController, animated: true, completion: nil)
    }

    func dismiss(animated: Bool = true) {
        viewController?.dismiss(animated: animated, completion: nil)
    }
}
