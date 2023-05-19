import Combine
import UIKit

class HomeViewController: UIViewController {

    private let defaultMargin: CGFloat = 16

    private let viewModel: HomeViewModel

    private var cancellables = Set<AnyCancellable>()

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
        logoutButton = UIButton()
        view.addSubview(logoutButton)

        privilagesLabel = UILabel()
        view.addSubview(privilagesLabel)
    }

    func styleViews() {
        view.backgroundColor = .white

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

        logoutButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(defaultMargin)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(48)
        }
    }

}
