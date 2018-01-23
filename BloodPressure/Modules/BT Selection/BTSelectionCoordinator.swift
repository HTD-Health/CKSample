import UIKit
import CoreBluetooth

class BTSelectionCoordinator: CoordinatorType {
    weak var navigationController: UINavigationController?
    weak var delegate: CoordinatorDelegate?

    func start(in navigationController: UINavigationController) {
        let viewModel = BTSelectionViewModel(bluetoothManager: bluetoothManager, coordinator: self)
        let selectionViewController = BTSelectionViewController(viewModel: viewModel)
        viewModel.viewController = selectionViewController
        let childNavigationController = UINavigationController(rootViewController: selectionViewController)

        navigationController.present(childNavigationController, animated: true, completion: nil)
        self.navigationController = childNavigationController
    }

    
    private lazy var bluetoothManager = BluetoothManager()

    func dismiss(animated: Bool = true) {
        self.navigationController?.dismiss(animated: animated, completion: nil)
    }

    func presentMeasurementVC(for peripheral: CBPeripheral) {
        guard let navigationConroller = self.navigationController else { return }
        let measurementCoordinator = HRMeasurementCoordinator(bluetoothManager: bluetoothManager)
        measurementCoordinator.delegate = self
        measurementCoordinator.start(in: navigationConroller)
    }
}

extension BTSelectionCoordinator: CoordinatorDelegate {
    func coordinatorDidFinish(coordinator: CoordinatorType) {
        print("measurementCoordinator did finish")
    }
}
