import UIKit

class Router: RouterProtocol {

    private var navigationController: UINavigationController

    init() {
        navigationController = UINavigationController()
    }

    func start(in window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        showTabController()
    }

    func showTabController() {
        let loginViewController = LoginViewController()
        let checkoutViewController = CheckoutViewController()

        let tabbarController = UITabBarController()
        tabbarController.setViewControllers([loginViewController, checkoutViewController], animated: true)

        tabbarController.tabBar.backgroundColor = .white

        navigationController.setViewControllers([tabbarController], animated: true)
    }

    func goBack() {
        navigationController.popViewController(animated: true)
    }

}
