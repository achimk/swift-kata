//: [Previous](@previous)

import Foundation

struct DigitsValidationRule {
    
    let pattern = "^[0-9].*$"
    
    func validate(_ value: String?) -> Bool {
        
        guard let value = value else { return false }
        
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: value)
    }
}

typealias Money = Int
typealias PositiveMoney = Money
struct ValidationError {
    var fieldName: String
    var errorDescription: String
}

typealias  OrderedPaymentDocuments = [Int]

struct ChequeNumber {
    
    let value: String
    
    init?(_ value: String?) {
        guard DigitsValidationRule().validate(value) else { return nil }
        self.value = value!
    }
}

enum AccountPayment {
    case advance(PositiveMoney)
    case charge(PositiveMoney)
}

enum PaymentMethod {
    case cash
    case transfer
    case cheque(ChequeNumber)
}

struct UnvalidatedPaymentMethod {
    var account: AccountPayment?
    var method: PaymentMethod?
}

enum ValidatedPaymentMethod {
    case accountCharge(PositiveMoney)
    case accountPartialCharge(PositiveMoney, method: PaymentMethod)
    case accountAdvance(PositiveMoney, method: PaymentMethod)
    case method(PaymentMethod)
}

typealias ValidatePaymentMethod = (UnvalidatedPaymentMethod, OrderedPaymentDocuments) -> Result<ValidatedPaymentMethod, Swift.Error>


//typealias AccountPaymentMethodService = (AccountPayment?, PaymentMethod?, OrderedPaymentDocuments) -> AccountPaymentMethod?
//
//enum PaymentType {
//    case incoming
//    case outgoing
//}
//
//struct Payment {
//    let total: Money
//    let method: AccountPaymentMethod
//    let documents: OrderedPaymentDocuments
//}
//
//typealias PaymentService = (OrderedPaymentDocuments, AccountPaymentMethod) -> Payment?

//: [Next](@next)
