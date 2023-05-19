import Combine
import Foundation

class LoginViewModel {

    private let router: RouterProtocol

    init(router: RouterProtocol) {
        self.router = router
    }

    func handleLogin(username: String?, password: String?) {
        guard
            !RASPService.isDeviceJailbroken(),
            !RASPService.isDebuggerAttached()
        else {
            router.presentAlert(
                title: "RASP check failed",
                message: "You can't login if you are maliciously using the app."
            )
            print("RASP check failed!")
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
