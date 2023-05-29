import Combine
import UIKit

class CheckoutViewController: UIViewController {

    private let defaultMargin: CGFloat = 16
    private let defaultViewHeight: CGFloat = 48

    private let viewModel: CheckoutViewModel

    private var cancellables = Set<AnyCancellable>()

    private var containerView: UIView!
    private var cardNumberTextField: UITextField!
    private var cardCVVTextField: UITextField!
    private var cardExpirationDateTextField: UITextField!
    private var payButton: UIButton!

    init(viewModel: CheckoutViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setTabBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = false
    }

    private func setTabBar() {
        tabBarItem = UITabBarItem(
            title: "Checkout",
            image: UIImage(systemName: "cart")?.withRenderingMode(.alwaysTemplate).withTintColor(.gray),
            selectedImage: UIImage(systemName: "cart")
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        buildViews()
        bindViews()
    }

    private func bindViews() {
        view
            .tap
            .sink { [weak self] _ in
                // Dismiss keyboard
                self?.view.endEditing(true)
            }
            .store(in: &cancellables)

        payButton
            .throttledTap()
            .sink { [weak self] _ in
                guard let self else { return }

                self.viewModel.pay(
                    cardNumber: self.cardNumberTextField.text,
                    cvv: self.cardCVVTextField.text,
                    expDate: self.cardExpirationDateTextField.text
                )
            }
            .store(in: &cancellables)
    }

}

extension CheckoutViewController: ConstructViewsProtocol {

    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }

    func createViews() {
        containerView = UIView()
        view.addSubview(containerView)

        cardNumberTextField = UITextField()
        containerView.addSubview(cardNumberTextField)

        cardCVVTextField = UITextField()
        containerView.addSubview(cardCVVTextField)

        cardExpirationDateTextField = UITextField()
        containerView.addSubview(cardExpirationDateTextField)

        payButton = UIButton()
        containerView.addSubview(payButton)
    }

    func styleViews() {
        view.backgroundColor = .white

        cardNumberTextField.borderStyle = .roundedRect
        cardNumberTextField.placeholder = "Card number"
        cardNumberTextField.keyboardType = .numberPad

        cardCVVTextField.borderStyle = .roundedRect
        cardCVVTextField.placeholder = "CVV"
        cardCVVTextField.keyboardType = .numberPad

        cardExpirationDateTextField.borderStyle = .roundedRect
        cardExpirationDateTextField.placeholder = "Expiration date"

        payButton.setTitle("Pay", for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.backgroundColor = .black
        payButton.layer.cornerRadius = 10
    }

    func defineLayoutForViews() {
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(defaultMargin)
        }

        cardNumberTextField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(defaultViewHeight)
        }

        cardCVVTextField.snp.makeConstraints {
            $0.top.equalTo(cardNumberTextField.snp.bottom).offset(defaultMargin)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(containerView.snp.centerX).inset(defaultMargin / 2)
            $0.height.equalTo(defaultViewHeight)
        }

        cardExpirationDateTextField.snp.makeConstraints {
            $0.top.equalTo(cardNumberTextField.snp.bottom).offset(defaultMargin)
            $0.leading.equalTo(cardCVVTextField.snp.trailing).offset(defaultMargin)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(defaultViewHeight)
        }

        payButton.snp.makeConstraints {
            $0.top.equalTo(cardCVVTextField.snp.bottom).offset(defaultMargin)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(defaultViewHeight)
        }
    }

}
