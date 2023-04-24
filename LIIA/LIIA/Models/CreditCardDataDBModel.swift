import RealmSwift

class CreditCardDBModel: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var cardNumber: String
    @Persisted var cvv: String
    @Persisted var expirationDate: String;
}
