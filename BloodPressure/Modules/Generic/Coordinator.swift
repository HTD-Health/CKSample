import UIKit

protocol CoordinatorDelegate: class {
    func coordinatorDidFinish(coordinator: CoordinatorType)
}

protocol CoordinatorType: class {
    weak var navigationController: UINavigationController? { get }
    weak var delegate: CoordinatorDelegate? { get }
    func start(in navigationConttoller: UINavigationController)
}

//class DefaultCoordinator: Coordinator {
//
//    weak var navigationController: UINavigationController?
//    weak var delegate: CoordinatorDelegate?
//
////    init(navigationController: UINavigationController) {
////        self.navigationController = navigationController
////    }
//
//    func start() {
//        fatalError("Subclasses must implement start() method")
//    }
//}

//extension Coordinator {
//    func remove(coordinator child: Coordinator) {
//        if let index = childCoordinators.index(where: { $0 === child }) {
//            childCoordinators.remove(at: index)
//        }
//    }
//}

//protocol PushCoordinator: Coordinator {
//    weak var navigationController: UINavigationController? { get }
//
//    func push(in viewController: UIViewController)
//    func pop(animated: Bool)
//}
//
//protocol ModalCoordinator: Coordinator {
//    func present(in navigationController: UINavigationController)
//    func dismiss(animated: Bool)
//}
//
//extension PushCoordinator {
//    func pop(animated: Bool = true) {
//        navigationController?.popViewController(animated: true)
//    }
//}
//
//extension ModalCoordinator {
//    func dismiss(animated: Bool = true) {
//        view?.dismiss(animated: true, completion: nil)
//    }
//}

