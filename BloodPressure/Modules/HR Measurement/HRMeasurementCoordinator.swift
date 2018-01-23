import UIKit

class HRMeasurementCoordinator: CoordinatorType {
    weak var navigationController: UINavigationController?
    weak var delegate: CoordinatorDelegate?
    weak var view: UIViewController?
    private let bluetoothManager: BluetoothManager

    init(bluetoothManager: BluetoothManager) {
        self.bluetoothManager = bluetoothManager
    }

    func start(in navigationController: UINavigationController) {
        let viewModel = HRMeasurementViewModel(bluetoothManager: bluetoothManager, coordinator: self)
        let viewController = HRMeasurementViewController(viewModel: viewModel)
        viewModel.viewController = viewController
        navigationController.pushViewController(viewController, animated: true)

        self.navigationController = navigationController
        self.view = viewController
   }

    func measurementDidFinish() {
        navigationController?.popViewController(animated: true)
        self.delegate?.coordinatorDidFinish(coordinator: self)
    }
}
