import Combine
import Foundation

class LoginViewModel {

    private let router: RouterProtocol

    init(router: RouterProtocol) {
        self.router = router
    }

    func handleLogin(username: String?, password: String?) {
        guard !RASPService.isDeviceJailbroken() else {
            router.presentError(
                title: "Jailbreak detected",
                message: "You can't login if your device is jailbroken."
            )
            return
        }

        if username == "admin", password == "admin" {
            UserDefaults.standard.isAdmin = true
        } else if username == "user", password == "user" {
            UserDefaults.standard.isAdmin = false
        } else {
            router.presentError(
                title: "Wrong credentials",
                message: "Try entering your credentials again."
            )
            return
        }

        router.login()
    }

}
