import Combine
import UIKit

class OTPViewController: UIViewController {

    private let defaultMargin: CGFloat = 16
    private let itemHeight: CGFloat = 48

    private let viewModel: OTPViewModel

    private var cancellables = Set<AnyCancellable>()

    private var pinAuthContainerView: UIStackView!
    private var pinTextField: UITextField!
    private var okButton: UIButton!
    private var faceIdButton: UIButton!
    private var otpContainerView: UIStackView!
    private var otpTitleLabel: UILabel!
    private var otpValueLabel: UILabel!

    init(viewModel: OTPViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = false
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

        faceIdButton
            .throttledTap()
            .flatMap { [weak self] _ -> AnyPublisher<Bool, Never> in
                guard let self else { return .empty() }

                return self.viewModel.authenticateWithFaceID()
            }
            .sink { [weak self] successfullyAuthenticated in
                guard
                    let self,
                    successfullyAuthenticated
                else {
                    self?.viewModel.handleAuthFailed()
                    return
                }

                self.otpValueLabel.text = self.viewModel.generateOTP()
                self.pinAuthContainerView.isHidden = true
                self.otpContainerView.isHidden = false
            }
            .store(in: &cancellables)

        okButton
            .throttledTap()
            .sink { [weak self] _ in
                guard
                    let self,
                    self.viewModel.authenticatePin(self.pinTextField.text)
                else {
                    self?.viewModel.handleAuthFailed()
                    return
                }

                self.otpValueLabel.text = self.viewModel.generateOTP()
                self.pinAuthContainerView.isHidden = true
                self.otpContainerView.isHidden = false
            }
            .store(in: &cancellables)
    }

}

extension OTPViewController: ConstructViewsProtocol {

    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }

    func createViews() {
        pinAuthContainerView = UIStackView()
        view.addSubview(pinAuthContainerView)

        pinTextField = UITextField()
        pinAuthContainerView.addArrangedSubview(pinTextField)

        okButton = UIButton()
        pinAuthContainerView.addArrangedSubview(okButton)

        faceIdButton = UIButton()
        pinAuthContainerView.addArrangedSubview(faceIdButton)

        otpContainerView = UIStackView()
        view.addSubview(otpContainerView)

        otpTitleLabel = UILabel()
        otpContainerView.addArrangedSubview(otpTitleLabel)

        otpValueLabel = UILabel()
        otpContainerView.addArrangedSubview(otpValueLabel)
    }

    func styleViews() {
        view.backgroundColor = .white

        pinAuthContainerView.axis = .vertical
        pinAuthContainerView.spacing = defaultMargin

        pinTextField.borderStyle = .roundedRect
        pinTextField.placeholder = "Enter your PIN"
        pinTextField.isSecureTextEntry = true
        pinTextField.keyboardType = .numberPad

        okButton.backgroundColor = .black
        okButton.setTitleColor(.white, for: .normal)
        okButton.setTitle("OK", for: .normal)
        okButton.layer.cornerRadius = 10

        faceIdButton.backgroundColor = .black
        faceIdButton.setTitleColor(.white, for: .normal)
        faceIdButton.setTitle("Authenticate with Biometrics", for: .normal)
        faceIdButton.layer.cornerRadius = 10

        otpContainerView.axis = .vertical
        otpContainerView.spacing = defaultMargin
        otpContainerView.isHidden = true

        otpTitleLabel.text = "Your OTP"
        otpTitleLabel.textColor = .black

        otpValueLabel.textColor = .black
        otpValueLabel.font = .systemFont(ofSize: 32)
    }

    func defineLayoutForViews() {
        pinAuthContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(defaultMargin)
            $0.centerY.equalToSuperview()
        }

        pinTextField.snp.makeConstraints {
            $0.height.equalTo(itemHeight)
        }

        okButton.snp.makeConstraints {
            $0.height.equalTo(itemHeight)
        }

        faceIdButton.snp.makeConstraints {
            $0.height.equalTo(itemHeight)
        }

        otpContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(defaultMargin)
            $0.centerY.equalToSuperview()
        }
    }

}
