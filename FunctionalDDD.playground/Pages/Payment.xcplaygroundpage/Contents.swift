//: [Previous](@previous)

import Foundation

typealias ChequeNumber = Int

typealias CardNumber = String

enum CardType {
    case visa, mastercard
}

typealias CreditCardInfo = (CardType, CardNumber)

enum PaymentMethod {
    case cash
    case cheque(ChequeNumber)
    case card(CreditCardInfo)
}

typealias PaymentAmount = Decimal

enum Currency {
    case EUR, USD
}

struct Payment {
    var amount: PaymentAmount
    var currency: Currency
    var method: PaymentMethod
}

let amount: PaymentAmount = 10
let currency = Currency.USD
let creditCard: CreditCardInfo = (.visa, "123123123")
let method = PaymentMethod.card(creditCard)

let payment = Payment(amount: amount, currency: currency, method: method)

print(payment)

//: [Next](@next)
