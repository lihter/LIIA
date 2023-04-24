import Combine
import Foundation

class LoginViewModel {

    private let router: RouterProtocol

    init(router: RouterProtocol) {
        self.router = router
    }

    func handleLogin(username: String?, password: String?) {
        guard !RASPService.isDeviceJailbroken() else {
            router.presentAlert(
                title: "Jailbreak detected",
                message: "You can't login if your device is jailbroken."
            )
            print("Jailbreak detected!")
            return
        }

        if username == "admin", password == "admin" {
            UserDefaults.standard.isAdmin = true
            print("User logged in as admin")
        } else if username == "user", password == "user" {
            UserDefaults.standard.isAdmin = false
            print("User logged in as user")
        } else {
            router.presentAlert(
                title: "Wrong credentials",
                message: "Try entering your credentials again."
            )
            print("User entered wrong credentials...")
            return
        }

        router.login()
    }

}
