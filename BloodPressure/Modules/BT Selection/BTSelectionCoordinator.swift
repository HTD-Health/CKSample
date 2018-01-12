import UIKit
import CoreBluetooth

class BTSelectionCoordinator {
    private let navigationController = UINavigationController()
    private lazy var bluetoothManager = BluetoothManager()

    func presentBTSelection(in viewController: UIViewController) {
        let viewModel = BTSelectionViewModel(bluetoothManager: bluetoothManager, coordinator: self)
        let selectionViewController = BTSelectionViewController(viewModel: viewModel)
        viewModel.viewController = selectionViewController

        navigationController.viewControllers = [selectionViewController]
        viewController.present(navigationController, animated: true, completion: nil)
    }

    func dismiss(animated: Bool = true) {
        navigationController.dismiss(animated: animated, completion: nil)
    }

    func presentMeasurementVC(for peripheral: CBPeripheral) {
        let measVC = HRMeasurementViewController(bluetoothManager: bluetoothManager, peripheral: peripheral)
        navigationController.pushViewController(measVC, animated: true)
    }
}
