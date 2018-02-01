import Foundation
import RxSwift
import RxCocoa

class HRMeasurementViewModel: ViewModelType {

    typealias Coordinator = HRMeasurementCoordinator

    private let rxBTManager: RxBTManager

    let coordinator: Coordinator
    weak var viewController: HRMeasurementViewController?

    private var isRecording: Bool = false
    private var values = [Int]()

    let hrValue: Variable<BTHeartRateMeasurement?> = Variable(nil)

    let heartRateText = Variable<String>("--")
    let averageHeartRateText = Variable<String>("--")

    let measurementStatus = Variable<HRMeasurementStatus>(.disconnected)
    init(bluetoothManager: RxBTManager, coordinator: Coordinator) {
        self.rxBTManager = bluetoothManager
        self.coordinator = coordinator

    }

    func actionButtonTapped() {
        isRecording = !isRecording
        coordinator.stop()
    }


    func deviceButtonTapped() {
        coordinator.presentBTSelection()
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {

    }
}

enum HRMeasurementStatus {
    case disconnected
    case connected(String)
    case recording(String, String)
}
