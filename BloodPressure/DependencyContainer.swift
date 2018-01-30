import Foundation

class DependencyContainer {
    private lazy var storeManager = CarePlanStoreManager()
    private lazy var bluetoothManager = BTManager()
}

protocol SymptomTrackerFactory {
    func makeSymptomTrackerCoordinator() -> SymptomTrackerCoordinator
}

protocol CarePlanStoreFactory {
    func makeStoreManager() -> CarePlanStoreManager
    //func makeActivityManager() -> ActivityManager
}

protocol ConnectivityFactory {
    func makeBluetoothManager() -> BTManager
}

extension DependencyContainer: CarePlanStoreFactory {
    func makeStoreManager() -> CarePlanStoreManager {
        return storeManager
    }
}

extension DependencyContainer: SymptomTrackerFactory {
    func makeSymptomTrackerCoordinator() -> SymptomTrackerCoordinator {
        return SymptomTrackerCoordinator(factory: self)
    }
}

extension DependencyContainer: ConnectivityFactory {
    func makeBluetoothManager() -> BTManager {
        return bluetoothManager
    }
}
