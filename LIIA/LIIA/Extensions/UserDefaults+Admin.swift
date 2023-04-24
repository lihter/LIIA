import Foundation

public extension UserDefaults {

    @objc var isAdmin: Bool {
        get {
            bool(forKey: "admin")
        }
        set {
            set(newValue, forKey: "admin")
        }
    }

}
