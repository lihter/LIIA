import Combine
import Foundation
import LocalAuthentication

class OTPViewModel {

    private let router: RouterProtocol

    init(router: RouterProtocol) {
        self.router = router
    }

    func goBack() {
        router.goBack()
    }

    func generateOTP() -> String {
        var number = String()
        for _ in 0..<4 {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }

    func authenticatePin(_ pin: String?) -> Bool {
        guard let pin else { return false }

        return pin == "1111"
    }

    func handleAuthFailed() {
        router.presentAlert(
            title: "Authentication failed",
            message: "Try authenticating again."
        )
        print("User failed authentication for OTP...")
    }

    func authenticateWithFaceID() -> Bool {
        let context = LAContext()
        var error: NSError?
        var hasAuthenticated = false

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Authenticate to get One-time password"
            ) { success, authenticationError in
                hasAuthenticated = true
            }
        }

        return hasAuthenticated
    }

    func authenticateWithFaceID() -> AnyPublisher<Bool, Never> {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return Just(false).eraseToAnyPublisher()
        }

        return Deferred {
            Future { () -> Bool in
                do {
                    return try await context.evaluatePolicy(
                        .deviceOwnerAuthenticationWithBiometrics,
                        localizedReason: "Authenticate to get One-time password"
                    )
                } catch { return false }
            }
        }
        .first()
        .receiveOnMain()
        .eraseToAnyPublisher()
    }

}
