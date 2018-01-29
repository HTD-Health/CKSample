import UIKit

final class App {
    private let application: UIApplication
    private lazy var rootContainer = RootViewController()
    private let rootTabScreen = UITabBarController()

    private lazy var symptomTrackerCoordinator = container.makeSymptomTrackerCoordinator()
    private lazy var container = DependencyContainer()

    init(application: UIApplication, window: UIWindow) {
        self.application = application
        window.rootViewController = rootContainer
        window.makeKeyAndVisible()
        rootTabScreen.viewControllers = [symptomTrackerCoordinator.symptomTracker()]
        rootContainer.embed(viewController: rootTabScreen)
    }
}
