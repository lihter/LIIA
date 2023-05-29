import Combine
import UIKit

class HomeViewController: UIViewController {

    private let defaultMargin: CGFloat = 16

    private let viewModel: HomeViewModel

    private var cancellables = Set<AnyCancellable>()

    private var buttonContainer: UIStackView!
    private var otpButton: UIButton!
    private var logoutButton: UIButton!
    private var privilagesLabel: UILabel!

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setTabBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    private func setTabBar() {
        tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate).withTintColor(.gray),
            selectedImage: UIImage(systemName: "house")
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        buildViews()
        bindViews()
    }

    private func bindViews() {
        otpButton
            .throttledTap()
            .sink { [weak self] _ in
                self?.viewModel.handleOtpTapped()
            }
            .store(in: &cancellables)

        logoutButton
            .throttledTap()
            .sink { [weak self] _ in
                self?.viewModel.logout()
            }
            .store(in: &cancellables)

        UserDefaults
            .standard
            .publisher(for: \.isAdmin)
            .sink { [weak self] isAdmin in
                self?.privilagesLabel.text = isAdmin ? "Admin privilages" : "Normal privilages"
            }
            .store(in: &cancellables)
    }

}

extension HomeViewController: ConstructViewsProtocol {

    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }

    func createViews() {
        buttonContainer = UIStackView()
        view.addSubview(buttonContainer)

        otpButton = UIButton()
        buttonContainer.addArrangedSubview(otpButton)

        logoutButton = UIButton()
        buttonContainer.addArrangedSubview(logoutButton)

        privilagesLabel = UILabel()
        view.addSubview(privilagesLabel)
    }

    func styleViews() {
        view.backgroundColor = .white

        buttonContainer.axis = .vertical
        buttonContainer.spacing = defaultMargin

        otpButton.backgroundColor = .black
        otpButton.setTitleColor(.white, for: .normal)
        otpButton.setTitle("mToken", for: .normal)
        otpButton.layer.cornerRadius = 10

        logoutButton.backgroundColor = .black
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.layer.cornerRadius = 10

        privilagesLabel.textColor = .black
        privilagesLabel.textAlignment = .center
    }

    func defineLayoutForViews() {
        privilagesLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(defaultMargin)
            $0.leading.trailing.equalToSuperview().inset(defaultMargin)
        }

        buttonContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(defaultMargin)
            $0.centerY.equalToSuperview()
        }

        otpButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }

        logoutButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }

}
