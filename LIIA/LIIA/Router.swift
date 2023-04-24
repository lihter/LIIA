import UIKit

class Router: RouterProtocol {

    private var navigationController: UINavigationController

    init() {
        navigationController = UINavigationController()
    }

    func start(in window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        showLoginScreen()
    }

    func showLoginScreen() {
        let loginViewModel = LoginViewModel(router: self)
        let loginViewController = LoginViewController(viewModel: loginViewModel)

        navigationController.setViewControllers([loginViewController], animated: true)
    }

    func goBack() {
        navigationController.popViewController(animated: true)
    }

    func presentError(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        navigationController.present(alert, animated: true, completion: nil)
    }

    func login() {
        let homeViewModel = HomeViewModel(router: self)
        let homeViewController = HomeViewController(viewModel: homeViewModel)

        let checkoutViewController = CheckoutViewController()

        let tabbarController = UITabBarController()
        tabbarController.tabBar.backgroundColor = .white
        tabbarController.setViewControllers([homeViewController, checkoutViewController], animated: true)

        navigationController.setViewControllers([tabbarController], animated: true)
    }

}
