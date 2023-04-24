class HomeViewModel {

    private let router: RouterProtocol

    init(router: RouterProtocol) {
        self.router = router
    }

    func logout() {
        router.showLoginScreen()
    }

}
