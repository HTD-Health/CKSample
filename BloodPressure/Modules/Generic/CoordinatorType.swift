import UIKit

protocol CoordinatorType: class {
    associatedtype ViewController: UIViewController//, ViewControllerType

    var navigationController: UINavigationController { get }

    func start()
    func stop()

    func makeViewController() -> UIViewController
}

protocol PushPopCoordinatorType: CoordinatorType { }

extension PushPopCoordinatorType {
    func start() {
        let viewController = makeViewController()
        navigationController.pushViewController(viewController, animated: true)
    }

    func stop() {
        navigationController.popViewController(animated: true)
    }
}

protocol ModalCoordinatorType: CoordinatorType {}

extension ModalCoordinatorType {
    func start() {
        let viewController = makeViewController()
        navigationController.present(viewController, animated: true, completion: nil)
    }

    func stop() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
