import Foundation

protocol ViewModelType {
    associatedtype Coordinator: CoordinatorType

    var coordinator: Coordinator { get }
    func viewDidLoad()
}

extension ViewModelType {
    func viewDidLoad() {
        // empty implementation
    }
}
