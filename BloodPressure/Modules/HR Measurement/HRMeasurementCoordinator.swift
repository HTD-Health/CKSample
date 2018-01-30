import UIKit

class HRMeasurementCoordinator: ModalCoordinatorType {
    typealias ViewController = HRMeasurementViewController

    var navigationController: UINavigationController
    weak var viewController: ViewController?
    private lazy var bluetoothManager = BTManager()
    private lazy var rxBtManager = RxBTManager()
    private let assessment: Assessment
    private weak var childNavigationController: UINavigationController?

    init(navigationController: UINavigationController, assessment: Assessment) {
        self.navigationController = navigationController
        self.assessment = assessment
    }

    func makeViewController() -> UIViewController {
        let viewModel = HRMeasurementViewModel(bluetoothManager: rxBtManager, coordinator: self)
        let viewController = HRMeasurementViewController(viewModel: viewModel)
        viewModel.viewController = viewController
        let childNavigationController = UINavigationController(rootViewController: viewController)
        self.childNavigationController = childNavigationController
        return childNavigationController
    }

    func presentBTSelection() {
        let btSelectionCoordinator = BTSelectionCoordinator(navigationController: childNavigationController!,
                                                            bluetoothManager: rxBtManager)
        btSelectionCoordinator.start()
    }
}
