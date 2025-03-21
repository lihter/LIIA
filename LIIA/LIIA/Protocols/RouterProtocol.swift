import UIKit

protocol RouterProtocol {

    func start(in window: UIWindow)

    func showLoginScreen()

    func goBack()

    func presentAlert(title: String?, message: String?)

    func login()

}
