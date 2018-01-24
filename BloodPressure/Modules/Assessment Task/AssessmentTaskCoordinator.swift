import ResearchKit
import CareKit

class AssessmentTaskCoordinator: CoordinatorType {
    typealias Factory = CarePlanStoreFactory

    private weak var viewController: UIViewController?
    private let factory: Factory
    private let assessment: Assessment

    private lazy var storeManager = factory.makeStoreManager()
    weak var navigationController: UINavigationController?

    init(factory: Factory, assessment: Assessment) {
        self.factory = factory
        self.assessment = assessment
    }

    func start(in navigationConttoller: UINavigationController) {
        let viewModel = AssessmentTaskViewModel(coordinator: self, assessment: assessment, storeManager: storeManager)
        let taskViewController = AssessmentTaskViewController(viewModel: viewModel, task: assessment.task, taskRun: nil)
        viewController = taskViewController
        navigationConttoller.present(taskViewController, animated: true, completion: nil)
    }

    func dismiss(animated: Bool = true) {
        viewController?.dismiss(animated: animated, completion: nil)
    }
}
