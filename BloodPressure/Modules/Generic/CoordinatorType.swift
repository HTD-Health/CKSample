import UIKit

//protocol CoordinatorDelegate: class {
//    func coordinatorDidFinish(coordinator: CoordinatorType)
//}

protocol CoordinatorType: class {
    //associatedtype ViewModel: ViewModelType

    weak var navigationController: UINavigationController? { get }
    //weak var delegate: CoordinatorDelegate? { get }
    func start(in navigationConttoller: UINavigationController)
}
