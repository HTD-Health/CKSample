import ResearchKit
import CareKit

class AssessmentTaskCoordinator: ModalCoordinatorType {
    typealias Factory = CarePlanStoreFactory
    typealias ViewController = AssessmentTaskViewController

    private let factory: Factory
    private let assessment: Assessment
    let navigationController: UINavigationController

    private lazy var storeManager = factory.makeStoreManager()

    init(factory: Factory, assessment: Assessment, navigationController: UINavigationController) {
        self.factory = factory
        self.assessment = assessment
        self.navigationController = navigationController
    }

    func makeViewController() -> UIViewController {
        let viewModel = AssessmentTaskViewModel(coordinator: self, assessment: assessment, storeManager: storeManager)
        return ViewController(viewModel: viewModel, task: assessment.task, taskRun: nil)
    }
}
