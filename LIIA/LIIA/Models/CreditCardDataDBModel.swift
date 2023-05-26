import Foundation
import RealmSwift

class CreditCardDBModel: Object {

    @Persisted(primaryKey: true) var id: String
    @Persisted var cardNumber: String
    @Persisted var cvv: String
    @Persisted var expirationDate: String

    override init() {}

    init(_ cardNumber: String, _ cvv: String, _ expirationDate: String) {
        super.init()
        self.id = UUID().uuidString
        self.cardNumber = cardNumber
        self.cvv = cvv
        self.expirationDate = expirationDate
    }

}
