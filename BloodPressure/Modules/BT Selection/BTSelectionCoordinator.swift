import UIKit
import CoreBluetooth

class BTSelectionCoordinator: ModalCoordinatorType {

    typealias ViewController = BTSelectionViewController

    let navigationController: UINavigationController
    private let bluetoothManager: BluetoothManager

    init(navigationController: UINavigationController, bluetoothManager: BluetoothManager) {
        self.navigationController = navigationController
        self.bluetoothManager = bluetoothManager
    }

    func makeViewController() -> UIViewController {
        let viewModel = BTSelectionViewModel(bluetoothManager: bluetoothManager, coordinator: self)
        let selectionViewController = BTSelectionViewController(viewModel: viewModel)
        viewModel.viewController = selectionViewController
        let navigatonController = UINavigationController(rootViewController: selectionViewController)
        return navigatonController
    }
}
