import Foundation
import Security
import RealmSwift

class DataSource: DataSourceProtocol {

    static let shared = DataSource()

    private let realm: Realm

    init() {
        do {
            realm = try Realm()
        } catch { fatalError("Realm failed to initialise") }
    }

    func saveCardInfo(cardNumber: String, cvv: String, expDate: String) {
        saveToKeychain(cardNumber: cardNumber, cvv: cvv, expDate: expDate)

        saveToDatabase(cardNumber: cardNumber, cvv: cvv, expDate: expDate)

        sendToRemoteServer(cardNumber: cardNumber, cvv: cvv, expDate: expDate)
    }

    private func saveToKeychain(cardNumber: String, cvv: String, expDate: String) {
        var error: Unmanaged<CFError>?

        guard
            let cardNumberData = cardNumber.data(using: .utf8),
            let cvvData = cvv.data(using: .utf8),
            let access = SecAccessControlCreateWithFlags(
                kCFAllocatorDefault,
                kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                SecAccessControlCreateFlags.biometryAny,
                &error
            )
        else { return }

        let cardNumberAttributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "cardNumber",
            kSecValueData as String: cardNumberData
        ]

        SecItemAdd(cardNumberAttributes as CFDictionary, nil)

        let cvvAttributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "cvv2",
            kSecAttrAccessControl as String: access,
            kSecValueData as String: cvvData
        ]

        SecItemAdd(cvvAttributes as CFDictionary, nil)
    }

    private func saveToDatabase(cardNumber: String, cvv: String, expDate: String) {
        let cardModel = CreditCardDBModel(cardNumber, cvv, expDate)

        do {
            try realm.write {
                realm.add(cardModel)
            }
        } catch { print("Realm failed to save data") }
    }

    private func sendToRemoteServer(cardNumber: String, cvv: String, expDate: String) {
        let url = URL(string: "http://random-website-url.xyz")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "cardNumber": cardNumber,
            "cvv": cvv,
            "expirationDate": expDate
        ]

        do {
          request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
          print(error.localizedDescription)
          return
        }

        URLSession.shared.dataTask(with: request).resume()
    }

}
