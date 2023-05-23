class HomeViewModel {

    private let router: RouterProtocol

    init(router: RouterProtocol) {
        self.router = router
    }

    func logout() {
        print("User logged out")
        router.showLoginScreen()
    }

    func handleOtpTapped() {
        print("Handle OTP tapped")
        router.showOTPScreen()
    }

}
