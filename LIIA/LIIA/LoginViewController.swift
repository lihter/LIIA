import UIKit

class LoginViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)

        setTabBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setTabBar() {
        tabBarItem = UITabBarItem(
            title: "Login",
            image: UIImage(systemName: "person.badge.key")?.withRenderingMode(.alwaysTemplate).withTintColor(.gray),
            selectedImage: UIImage(systemName: "person.badge.key")
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }

}
