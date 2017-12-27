import UIKit

final class App {
    private let application: UIApplication
    private lazy var rootContainer = RootViewController()
    private let rootTabScreen = UITabBarController()
    private let storeManager: CarePlanStoreManager
    private let screens: Screens

    init(application: UIApplication, window: UIWindow) {
        self.application = application
        storeManager = CarePlanStoreManager()
        screens = Screens(storeManager: storeManager)
        window.rootViewController = rootContainer
        window.makeKeyAndVisible()
        rootTabScreen.viewControllers = [screens.symptomTracker()]
        rootContainer.embed(viewController: rootTabScreen)
    }
}
