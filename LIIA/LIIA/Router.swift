import UIKit

class Router: RouterProtocol {

    private var navigationController: UINavigationController

    init() {
        navigationController = UINavigationController()
    }

    func start(in window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        showHome()
    }

    func showHome() {
        let viewController = ViewController()

        navigationController.setViewControllers([viewController], animated: true)
    }

    func goBack() {
        navigationController.popViewController(animated: true)
    }

}
