//: [Previous](@previous)

import Foundation

typealias Money = Int
typealias PositiveMoney = Money

typealias ChequeNumber = Int

typealias ValidateChequeNumber = (Int) -> Result<ChequeNumber, Swift.Error>
typealias ValidateChargeAccountPayment = (Money, Account) -> Result<AccountPayment, Swift.Error>
typealias ValidateAdvanceAccountPayment = (Money, Account) -> Result<AccountPayment, Swift.Error>


struct Account {
    let id: String
    let balance: Money
}

struct PaymentDocument {
    let id: String
    let total: Money
}

struct OrderedPaymentDocuments {
    let first: PaymentDocument
    let other: [PaymentDocument]
    let total: PositiveMoney
    let partner: Account
}

enum AccountPayment {
    case charge(PositiveMoney)
    case advance(PositiveMoney)
}

enum PaymentMethod {
    case cash
    case transfer
    case cheque(ChequeNumber)
}

enum AccountPaymentMethod {
    case charge(PositiveMoney)
    case partialCharge(PositiveMoney, method: PaymentMethod)
    case advance(PositiveMoney, method: PaymentMethod)
}

enum PaymentMethodInfo {
    case direct(PaymentMethod)
    case account(AccountPaymentMethod)
}

struct Payment {
    let total: Money
    let method: PaymentMethodInfo
    let documents: OrderedPaymentDocuments
}

//: [Next](@next)
