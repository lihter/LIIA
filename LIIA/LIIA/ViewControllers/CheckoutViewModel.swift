class CheckoutViewModel {

    private let router: RouterProtocol
    private let dataSource: DataSourceProtocol

    init(router: RouterProtocol, dataSource: DataSourceProtocol) {
        self.router = router
        self.dataSource = dataSource
    }

    func pay(cardNumber: String?, cvv: String?, expDate: String?) {
        guard let cardNumber, let cvv, let expDate else { return }

        dataSource.saveCardInfo(cardNumber: cardNumber, cvv: cvv, expDate: expDate)

        router.presentAlert(
            title: "Transaction successful",
            message: "You will be able to see your transaction in a few minutes."
        )
    }

}
