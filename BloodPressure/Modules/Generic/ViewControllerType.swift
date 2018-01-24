import Foundation

protocol ViewControllerType {
    associatedtype ViewModel: ViewModelType

    var viewModel: ViewModel { get }
}
