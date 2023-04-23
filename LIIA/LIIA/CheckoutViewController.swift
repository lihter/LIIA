import UIKit

class CheckoutViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)

        setTabBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        view.backgroundColor = .green
    }

}
