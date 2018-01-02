import Foundation

class DependencyContainer {
    private lazy var storeManager = CarePlanStoreManager()
}

protocol SymptomTrackerFactory {
    func makeSymptomTrackerCoordinator() -> SymptomTrackerCoordinator
}

protocol CarePlanStoreFactory {
    func makeStoreManager() -> CarePlanStoreManager
    //func makeActivityManager() -> ActivityManager
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
