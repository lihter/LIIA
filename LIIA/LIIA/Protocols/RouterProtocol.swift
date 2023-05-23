import UIKit

protocol RouterProtocol {

    func start(in window: UIWindow)

    func showLoginScreen()

    func showOTPScreen()

    func goBack()

    func presentAlert(title: String?, message: String?)

    func login()

}
