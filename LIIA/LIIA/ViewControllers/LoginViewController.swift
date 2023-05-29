import Combine
import UIKit
import SnapKit

class LoginViewController: UIViewController {

    private let defaultMargin: CGFloat = 16
    private let defaultViewHeight: CGFloat = 48

    private let viewModel: LoginViewModel

    private var cancellables = Set<AnyCancellable>()

    private var containerView: UIView!
    private var usernameTextField: UITextField!
    private var passwordTextField: UITextField!
    private var loginButton: UIButton!
    private var termsAndConditionsButton: UIButton!
    private var subscribeWebViewContainer: UIView!
    private var subscribeWebView: UIWebView!

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        buildViews()
        bindViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    private func bindViews() {
        view
            .tap
            .sink { [weak self] _ in
                // Dismiss keyboard
                self?.view.endEditing(true)
            }
            .store(in: &cancellables)

        loginButton
            .throttledTap()
            .sink { [weak self] _ in
                guard let self else { return }

                self.viewModel.handleLogin(
                    username: self.usernameTextField.text,
                    password: self.passwordTextField.text
                )
            }
            .store(in: &cancellables)

        termsAndConditionsButton
            .throttledTap()
            .sink { [weak self] _ in
                guard let self else { return }

                self.loadWebView()
                self.subscribeWebViewContainer.isHidden = false
            }
            .store(in: &cancellables)

        subscribeWebViewContainer
            .tap
            .sink { [weak self] _ in
                self?.subscribeWebViewContainer.isHidden = true
            }
            .store(in: &cancellables)
    }

    private func loadWebView() {
        guard let url = URL(string: "http://sudo.co.il/xss/level1.php") else { return }

        let request = URLRequest(url: url)

        subscribeWebView.loadRequest(request)

        if let filePath = Bundle.main.path(forResource: "hack", ofType: "html") {
            subscribeWebView.loadRequest(URLRequest(url: URL(fileURLWithPath: filePath)))
        }
    }

}

extension LoginViewController: ConstructViewsProtocol {

    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }

    func createViews() {
        containerView = UIView()
        view.addSubview(containerView)

        usernameTextField = UITextField()
        containerView.addSubview(usernameTextField)

        passwordTextField = UITextField()
        containerView.addSubview(passwordTextField)

        loginButton = UIButton()
        containerView.addSubview(loginButton)

        termsAndConditionsButton = UIButton()
        containerView.addSubview(termsAndConditionsButton)

        subscribeWebViewContainer = UIView()
        view.addSubview(subscribeWebViewContainer)

        subscribeWebView = UIWebView()
        subscribeWebViewContainer.addSubview(subscribeWebView)
    }

    func styleViews() {
        view.backgroundColor = .white

        usernameTextField.borderStyle = .roundedRect
        usernameTextField.placeholder = "Username"

        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true

        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = 10

        termsAndConditionsButton.setTitle("Terms and Conditions", for: .normal)
        termsAndConditionsButton.setTitleColor(.black, for: .normal)

        subscribeWebViewContainer.backgroundColor = .black.withAlphaComponent(0.5)
        subscribeWebViewContainer.isHidden = true

        subscribeWebView.largeContentTitle = "JS inject vulnerability"
        subscribeWebView.delegate = self
    }

    func defineLayoutForViews() {
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(defaultMargin)
        }

        usernameTextField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(defaultViewHeight)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(usernameTextField.snp.bottom).offset(defaultMargin)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(defaultViewHeight)
        }

        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(defaultMargin)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(defaultViewHeight)
        }

        termsAndConditionsButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(defaultMargin)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        subscribeWebViewContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        subscribeWebView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

}

extension LoginViewController: UIWebViewDelegate { }
